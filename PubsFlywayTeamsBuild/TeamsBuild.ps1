﻿<# tell PowerShell where Flyway is. You need to change that to the correct path for your installation.
You only need to do this if your flyway installation has not provideded a path cvommand #>
#Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-8.0.2\flyway.cmd' -Scope local
$FlywayCommand=(Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand) {
    throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0') {
    throw "Your Flyway Version is too outdated to work"
}
#specify the DSN, and create the ODVC connection

# and here are our project details. The project folder
$ProjectFolder = '<PathToProjectFolder e.g. PubsAndFlyway\PubsFlywayTeamsMigration>'
$Server = '<MyUserName>';
$Schemas = '<MyListOfSchemas>';
$Database = '<MyDatabaseName>';
<# you only need this username and password if there is no domain authentication #>
$username = '<MyUserName>'
$port = '<MyPortNumber>'

# add a bit of error-checking. are the various directories there
@{'Project Directory'="$ProjectFolder"; 
'Data Directory'="$ProjectFolder\Data"; 
'Scripts Directory'="$ProjectFolder\Scripts"}.GetEnumerator()|Foreach{
    if (-not (Test-Path $_.Value))
    { Write-Error "Sorry, but I couldn't find a $($_.Name) at the $($_.Value) location" }
}
<# we will need to retrieve credentials #>   
if ($username -ne '') #then it is using SQL Server Credentials
{
	# we see if we've got these stored already
	$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($username)-$Server-sqlserver.xml"
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
	$FlywayBuildArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database",
		"-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
		"-user=$($SqlCredentials.UserName)",
		"-password=$($SqlCredentials.GetNetworkCredential().password)")
}

else
{
	$FlywayBuildArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true".
		"-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
}
$FlywayBuildArgs += <# the project variables that we reference with placeholders #>
@(
	"-schemas=$Schemas",
	"-placeholders.schemas=$Schemas", #This isn't passed to callbacks otherwise
	"-placeholders.projectDescription=$ProjectDescription",
	"-placeholders.projectName=$ProjectName")

cd "$ProjectFolder\scripts"

#if this works we're probably good to go
Flyway @FlywayBuildArgs info -teams
#then try it out!
Flyway @FlywayBuildArgs clean -teams
Flyway @FlywayBuildArgs migrate

