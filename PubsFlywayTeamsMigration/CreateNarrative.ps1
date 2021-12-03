#Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-8.0.2\flyway.cmd' -Scope local
$FlywayCommand=(Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand) {
    throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0') {
    throw "Your Flyway Version is too outdated to work"
}


<# tell PowerShell where Flyway is. You need to change that to the correct path for your installation.
You only need to do this if your flyway installation has not provideded a path cvommand #>

$Details = @{
	'server' = '<MyServer>'; #The Server name
	'database' = '<MyDatabaseName>'; #The Database
    'Port' = '<Database Port>'; #not all rdbms have these
	'uid' = '<MyUserName>'; #The User ID. you only need this if there is no domain authentication or secrets store #>
	'pwd' = ''; # The password. This gets filled in if you request it
	'version' = ''; # TheCurrent Version. This gets filled in if you request it
	'schemas' = '<listOfTheSchemas>';
	'project' = '<NameOfTheProject>'; #Just the simple name of the project
	'ProjectFolder' = '<MyPathTo>\PubsAndFlyway\PubsFlywayTeamsMigration'; #parent the scripts directory
	'ProjectDescription' = '<whatever you want attached to the project>'
	'Warnings' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                          
	'Problems' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                           
	'Locations' = @{ }; # Just leave this be. Filled in for your information
}


# add a bit of error-checking. Is the project directory there
if (-not (Test-Path "$($Details.ProjectFolder)"))
{ Write-Error "Sorry, but I couldn't find a project directory at the $ProjectFolder location" }
# ...and is the script directory there?
if (-not (Test-Path "$($Details.ProjectFolder)\Scripts"))
{ Write-Error "Sorry, but I couldn't find a scripts directory at the $ProjectFolder\Scripts location" }
# now we get the password if necessary
if ($Details.uid -ne '') #then it is using SQL Server Credentials
{
	# we see if we've got these stored already
	$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($Details.uid)-$($Details.server)-sqlserver.xml"
	# test to see if we know about the password in a secure string stored in the user area
	if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
	{
		#has already got this set for this login so fetch it
		$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
		
	}
	else #then we have to ask the user for it (once only)
	{
		# hasn't got this set for this login
		$SqlCredentials = get-credential -Credential $Details.uid
		# Save in the user area 
		$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
	}
	$FlywayNarrativeArgs =
	@("-url=jdbc:sqlserver://$($Details.Server)$(if([string]::IsNullOrEmpty($Details.port)){''}else{':'+$Details.port});databaseName=$($Details.database)",
		"-locations=filesystem:$($Details.projectFolder)\Scripts", <# the migration folder #>
		
"-user=$($SqlCredentials.UserName)",
		"-password=$($SqlCredentials.GetNetworkCredential().password)")
    $Details.pwd=$SqlCredentials.GetNetworkCredential().password;
    $Details.uid=$SqlCredentials.UserName
}
else
{
	$FlywayNarrativeArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Details.Database;integratedSecurity=true".
		"-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
}
$FlywayNarrativeArgs += <# the project variables that we reference with placeholders #>
@(
	"-schemas=$($Details.schemas)",
    '-errorOverrides=S0001:0:I-', #,S0001:50000:W-',
    "-placeholders.schemas=$($Details.schemas)", #This isn't passed to callbacks otherwise
	"-placeholders.projectDescription=$($Details.ProjectDescription)",
	"-placeholders.projectName=$($Details.Project)")

cd "$($details.ProjectFolder)\scripts"
. ..\DatabaseBuildAndMigrateTasks.ps1

# now we use the scriptblock to determine the version number and name from SQL Server

$ServerVersion = $GetdataFromSQLCMD.Invoke($details, "
 Select  Cast(ParseName ( Cast(ServerProperty ('productversion') AS VARCHAR(20)), 4) AS INT)")

[int]$VersionNumber = $ServerVersion[0]

if ($VersionNumber -ne $null)
{
	$FlywayNarrativeArgs +=
	@("-placeholders.canDoJSON=$(if ($VersionNumber -ge 13) { 'true' }
			else { 'false' })",
		"-placeholders.canDoStringAgg=$(if ($VersionNumber -ge 14) { 'true' }
			else { 'false' })")
}


#if this works we're probably good to go
Flyway @FlywayNarrativeArgs info

<# now we iterate through the versions we've actually achieved, and after
doing each migration successfully, we can then store a model of the metadata
as a JSON file to disk in the $versionpath we've just defined #>

$VersionsSoFar = @('1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6',
	'1.1.7', '1.1.8', '1.1.9', '1.1.10', '1.1.11')

$VersionsSoFar | foreach -begin { Flyway @FlywayNarrativeArgs clean } -process {
	Flyway @FlywayNarrativeArgs migrate "-target=$($_)"
}


#Now we can generate a report for every migration but the first. We store them in the project directory
#(not the scripts location directories) that contain alll our reports and scripts 
$PreviousVersion = $null; #
$ProjectLocation = "$($env:USERPROFILE)\Documents\GitHub\$($Details.Project)"
$VersionsSoFar | foreach{
	$Version = $_;
	if ($PreviousVersion -ne $null)
	{
		#see what is changed by comparing the models before and after the migration
		$Comparison = Diff-Objects -Parent $Details.Database -depth 10 <#get the previous model from file#>`
		([IO.File]::ReadAllText("$ProjectLocation\$PreviousVersion\Reports\DatabaseModel.JSON") |
			ConvertFrom-JSON)<#and get the current model from file#> `
		([IO.File]::ReadAllText("$ProjectLocation\$Version\Reports\DatabaseModel.JSON") |
			ConvertFrom-JSON) |
		where { $_.match -ne '==' }
		$Comparison | Export-CSV -Path "$ProjectLocation\$Version\Reports\MetadataChanges.report"
		$Comparison | ConvertTo-JSON > "$ProjectLocation\$Version\Reports\MetadataChanges.json"
		#we can do all sorts of more intutive reports from the output
	}
	$PreviousVersion = $Version;
}

<# Now we can generate the narrative. We use the changes report we generated in order
to produce the report. Here we've generated a markdown report but it can be almost 
anything you wish. Markdown is a useful intermediary and it looks good in Github.#>

$ItsCool = $true; # unless something goes wrong
$ProjectLocation = "$($env:USERPROFILE)\Documents\GitHub\$($Details.Project)"
#firstly we ask Flyway for the history table ...
$report = Flyway info  @FlywayNarrativeArgs -outputType=json | convertFrom-json
if ($report.error -ne $null) #if an error was reported by Flyway
{
	#if an error (usually bad parameters) error out.
	$report.error | foreach {
		"$($_.errorCode): $($_.message)"
		$ItsCool = $false
	}
}
if ($report.allSchemasEmpty) #if it is an empty database
{
	$ItsCool = $false;
	"all schemas of $($Details.database) are empty."
}
# unless we hit errors, we then produce the narrative
if ($ItsCool)
{
	#first put in the title
	$FinalReport = "# $($Details.database) Migration`n`n$($Details.ProjectDescription)`n`n"
	# skip the first version because there is no previous version to
	# compare it with
	$FinalReport += $VersionsSoFar | Select-Object -Skip 1 | foreach{
		$Version = $_;
		$VersionContent="## Version $Version`n"
		#fetch the changes report...
		$changes = ([IO.File]::ReadAllText("$ProjectLocation\$Version\Reports\MetadataChanges.json")
		) | ConvertFrom-JSON
		
		$VersionContent += $report.migrations | where { $_.version -eq $version } | foreach{
			"A $($_.type) migration, $($_.description), installed on $(([datetime]$_.installedOnUTC).tostring(“MM-dd-yyyy”)) by $($_.installedBy) taking $($_.executionTime) ms.`n"
		} # we actually only read the record for the current version 
		#now we document each change
		$VersionContent += $changes | foreach{
			$current = $_;
			switch ($current.Match)
			{
				'->' {
					"$(if ($current.Target -ne 'PSCustomObject')
						{ "- Added '$($current.Target)' to" }
						else { "- Added" }) '$($current.Ref)`n"
				}
				'<>' {
					"- Changed '$($current.Source)' to '$($current.Target
					)' at '$($current.Ref)`n"
				}
				'<-' {
					"- Deleted '$($current.Source)' at '$($current.Ref
					) with version $version'`n"
				}
				default { "No metadata change `n" }
			}
		
        }
    
    $VersionContent > "$ProjectLocation\$Version\Reports\Narrative.md"
    $VersionContent
	}
}
$FinalReport > "$ProjectLocation\NarrativeofVersions.md"



