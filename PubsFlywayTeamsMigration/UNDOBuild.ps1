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
#specify the DSN, and create the ODVC connection

$Details = @{
	'server' = '<MyServer>'; #The Server name
	'database' = '<MyDatabaseName>'; #The Database
	'uid' = '<MyUserName>'; #The User ID. you only need this if there is no domain authentication or secrets store #>
	'pwd' = ''; # The password. This gets filled in if you request it
	'version' = ''; # TheCurrent Version. This gets filled in if you request it
	'project' = '<NameOfTheProject>'; #Just the simple name of the project
	'ProjectFolder' = '<MyPathTo>\PubsAndFlyway\PubsFlywayTeamsMigration'; #parent the scripts directory
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
	$FlywayUndoArgs =
	@("-url=jdbc:sqlserver://$($Details.Server)$(if([string]::IsNullOrEmpty($Details.port)){''}else{':'+$Details.port});databaseName=$($Details.database)",
		"-locations=filesystem:$($Details.projectFolder)\Scripts", <# the migration folder #>
		"-user=$($SqlCredentials.UserName)",
		"-password=$($SqlCredentials.GetNetworkCredential().password)")
    $Details.pwd=$SqlCredentials.GetNetworkCredential().password;
    $Details.uid=$SqlCredentials.UserName
}
else
{
	$FlywayUndoArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true".
		"-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
}
$FlywayUndoArgs += <# the project variables that we reference with placeholders #>
@(
	"-schemas=$($Details.schemas)",
    '-errorOverrides=S0001:0:I-,S0001:50000:W-',
    "-placeholders.schemas=$($Details.schemas)", #This isn't passed to callbacks otherwise
	"-placeholders.projectDescription=$($Details.ProjectDescription)",
	"-placeholders.projectName=$($Details.Project)")

cd "$($details.ProjectFolder)\scripts"
. ..\DatabaseBuildAndMigrateTasks.ps1

<# now we use the scriptblock to determine the version number and name from SQL Server
#>
$ServerVersion = $GetdataFromSQLCMD.Invoke($details, "
 Select  Cast(ParseName ( Cast(ServerProperty ('productversion') AS VARCHAR(20)), 4) AS INT)")

[int]$VersionNumber = $ServerVersion[0]

if ($VersionNumber -ne $null)
{
	$FlywayUndoArgs +=
	@("-placeholders.canDoJSON=$(if ($VersionNumber -ge 13) { 'true' }
			else { 'false' })",
		"-placeholders.canDoStringAgg=$(if ($VersionNumber -ge 14) { 'true' }
			else { 'false' })")
}

<#
@('1.1.1','1.1.2','1.1.3','1.1.4',
'1.1.5','1.1.6','1.1.7','1.1.8',
'1.1.9','1.1.10','1.1.11')| foreach{
Flyway @FlywayUndoArgs migrate "-target=$_"
}
#>

#if this works we're probably good to go

Flyway @FlywayUndoArgs info -teams
Flyway @FlywayUndoArgs clean -teams
Flyway @FlywayUndoArgs migrate '-target=1.1.5'
Flyway @FlywayUndoArgs undo '-target=1.1.5'


$GetCurrentVersion.Invoke($Details)
