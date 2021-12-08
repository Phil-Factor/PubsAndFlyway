$FlywayCommand = (Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand)
{
	throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0')
{
	throw "Your Flyway Version is too outdated to work"
}

# The config items are case-sensitive camelcase so beware if you aren't used to this
# the SQL files need to have consistent encoding, preferably utf-8 unless you set config 
cd '<ThePathTo>\PubsAndFlyway\PubsFlywayHistorySchema'

# and here are our project details. The project folder
$Server = '<myServer>'
$Database = '<MyDatabase>';
$ProjectName = 'Publications';
$ProjectDescription = 'A sample project to demonstrate Flyway, using the old Pubs database'
<# you only need this username and password if there is no domain authentication #>
$username = '<MyUserID>'
$port = '1433'
# add a bit of error-checking. Is the project directory there
# ..is the script directory there?
if (-not (Test-Path "$(get-location)\Scripts" -PathType Container))
{ Write-Error "Sorry, but I couldn't find a scripts directory at the $(get-location)\Scripts location" }
if (-not (Test-Path "$(get-location)\flyway.conf" -PathType Leaf))
{ Write-Error "Sorry, but I couldn't find a flyway.conf file at the $(get-location) location" }
# now we get the password if necessary
if ($username -ne '') #then it is using SQL Server Credentials
{
	# we see if we've got these stored already
	$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($username)-$SourceServer.xml"
	# test to see if we know about the password in a secure string stored in the user area
	if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
	{
		#has already got this set for this login so fetch it
		$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
		
	}
	else #then we have to ask the user for it (once only)
	{
		# hasn't got this set for this login
		$SqlCredentials = get-credential -Credential $UserName
		# Save in the user area 
		$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
	}
	$FlyWayArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database",
		"-locations=filesystem:$(get-location)\Scripts", <# the migration folder #>
		"-user=$($SqlCredentials.UserName)",
		"-password=$($SqlCredentials.GetNetworkCredential().password)")
}
else
{
	$FlyWayArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true".
		"-locations=get-location\Scripts")<# the migration folder #>
}
$FlyWayArgs += <# the project variables that we reference with placeholders #>
@("-placeholders.projectDescription=$ProjectDescription",
	"-placeholders.projectName=$ProjectName") <# the project variables #>


Flyway clean  @FlyWayArgs # remove all objects from the database, including baselines
flyway info @FlyWayArgs # check that it has the correct plan for executing the scripts
Flyway migrate @FlyWayArgs

