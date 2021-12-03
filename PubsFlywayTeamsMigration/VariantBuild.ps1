<# tell PowerShell where Flyway is. You need to change that to the correct path for your installation.
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
$ProjectFolder = '<MyPathTo>\PubsAndFlyway\PubsFlywayTeamsMigration'
$Server = '<MyUserName>'
$Database = '<MyDatabaseName>';
$ProjectName = 'Publications';
$ProjectDescription = 'A sample project to demonstrate Flyway Teams, using the old Pubs database'
<# you only need this username and password if there is no domain authentication #>
$username = '<MyUserName>'
$port = '<MyPortNumber>'

# add a bit of error-checking. Is the project directory there
if (-not (Test-Path "$ProjectFolder"))
{ Write-Error "Sorry, but I couldn't find a project directory at the $ProjectFolder location" }
# ...and is the script directory there?
if (-not (Test-Path "$ProjectFolder\Scripts"))
{ Write-Error "Sorry, but I couldn't find a scripts directory at the $ProjectFolder\Scripts location" }
# now we get the password if necessary
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
	$FlyWayArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database",
		"-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
		"-user=$($SqlCredentials.UserName)",
		"-password=$($SqlCredentials.GetNetworkCredential().password)")
	$SQLCmdArgs = @{
		'Server' = $Server; 'Database' = $Database; 'User' = $SqlCredentials.UserName;
		'Password' = $SqlCredentials.GetNetworkCredential().password
	}
}
else
{
	$FlyWayArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true".
		"-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
	$SQLCmdArgs = @{ 'Server' = $Server; 'Database' = $Database }
}
$FlyWayArgs += <# the project variables that we reference with placeholders #>
@(
	"-schemas=dbo,Classic,people",
	"-placeholders.schemas=dbo,Classic,people", #This isn't passed to callbacks otherwise
	"-placeholders.projectDescription=$ProjectDescription",
	"-placeholders.projectName=$ProjectName")


<# if your install of the SQL Server utilities has added the environment PATH variable then
you don't need this #>
$SQLCmdAlias = "$($env:ProgramFiles)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe"
Set-Alias SQLCmd $SQLCmdAlias
<# we'll use a script block to access SQLCMD #>

$GetdataFromSQLCMD = {<# a way of accessing SQL Server to get JSON results withhout having to open a
connection. We are going to access the server via flyway and so only want one connection going #>
	Param ($Theargs,
		$query)
	$TempFile = "$($env:Temp)\Temp.json"
	$FullQuery = "Set Nocount On   $query"
	if ($TheArgs.User -ne $null)
	{
		sqlcmd -S $TheArgs.server -d $TheArgs.database -Q "`"$FullQuery`"" -U $TheArgs.User -P $TheArgs.password -o `"$TempFile`" -u -y0
	}
	else
	{
		sqlcmd -S $TheArgs.server -d $TheArgs.database -Q "`"$FullQuery`"" -o `"$TempFile`" -u -y0
	}
	If (Test-Path -Path $TempFile)
	{
		$response = [IO.File]::ReadAllText($TempFile);
		#Remove-Item $TempFile
		if ($response -like 'Msg*')
		{ "[{`"Error`":`"$($TheArgs.database) says $Response'`"}]" }
		elseif ($response -like 'SqlCmd*')
		{ "[{`"Error`":`"SQLCMD says $Response'`"}]" }
		elseif ($response -like 'NULL*')
		{ '' }
		else
		{ $response }
	}
}
<# now we use the scriptblock to determine the version number and name from SQL Server
#>
$ServerVersion = $GetdataFromSQLCMD.Invoke($SQLCmdArgs, "
 Select  Cast(ParseName ( Cast(ServerProperty ('productversion') AS VARCHAR(20)), 4) AS INT)")
[int]$VersionNumber = $ServerVersion[0]

if ($VersionNumber -ne $null)
{
	$FlyWayArgs +=
	@("-placeholders.canDoJSON=$(if ($VersionNumber -ge 13) { 'true' }
			else { 'false' })",
		"-placeholders.canDoStringAgg=$(if ($VersionNumber -ge 14) { 'true' }
			else { 'false' })")
}
cd "$ProjectFolder\scripts"


#if this works we're probably good to go

Flyway @FlyWayArgs info
Flyway @FlywayArgs clean
Flyway @FlyWayArgs migrate 
