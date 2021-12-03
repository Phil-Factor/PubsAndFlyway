#create an alias for the commandline Flyway with your path to Flyway., 
#Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-8.0.2\flyway.cmd' -Scope local
$FlywayCommand=(Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand) {
    throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0') {
    throw "Your Flyway Version is too outdated to work"
}
# and here are our project details. The project folder
$ProjectFolder = 'SMyPathTo\PubsAndFlyway\PubsFlywaySecondMigration'
$ReportFile = "$ProjectFolder\Reports\Testreport.json"
$Server = 'MyServer'
$Database = 'PubsThree';
<# you only need this username and password if there is no domain authentication #>

$username = 'MyUserID'
$port = '1433'
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
	$Uid = $SqlCredentials.UserName;
	$Pwd = $SqlCredentials.GetNetworkCredential().password
	
	$FlyWayArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database",
		"-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
		"-user=$($SqlCredentials.UserName)",
		"-password=$($SqlCredentials.GetNetworkCredential().password)")
}
else
{
	$FlyWayArgs =
	@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true".
		"-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
}
$FlyWayArgs += # the code to provide the switches to give JSON
@('-outputType=json',
	"-outputFile=$ReportFile"
	;)
$FlyWayArgs +=# the code to provide the switches for the afterMigrate script.
@('-placeholders.projectDescription=A sample project to show how to build a database and fill it with data';
  '-placeholders.ProjectName=Publications')

$report = flyway info '-target=1.1.8' $FlyWayArgs | convertfrom-JSON
if ($report.error -ne $null) { Write-error $Report.error.message }
else
{
	if ($report.migrations.Count -gt 0)
	{
		$report.migrations | select category, version, description, type, installedOn, state | format-table
		$TimespanFormat = "{0:mm} mins, {0:ss} secs."
		$report.migrations | Measure-Object -Property executionTime -Sum -Max -Min -Average |
		Select @{ Name = 'Sum'; Expression = { $TimespanFormat -f (New-TimeSpan -Seconds ($_.Sum/1000)) } },
			   @{ Name = 'Max'; Expression = { $TimespanFormat -f (New-TimeSpan -Seconds ($_.Maximum/1000)) } },
			   @{ Name = 'Minimum'; Expression = { $TimespanFormat -f (New-TimeSpan -Seconds ($_.Minimum/1000)) } },
			   @{ Name = 'Ave'; Expression = { $TimespanFormat -f (New-TimeSpan -Seconds ($_.Average/1000)) } }
	}
	if ($report.warnings.Count -gt 0){ 
       $report.warnings | format-table }
	$report | gm -MemberType NoteProperty | #turn it into a hash table for easiest display.
	where { $_.Name -notin @('warnings', 'migrations') } |
	foreach{ @{ $_.Name = $report."$($_.name)" } }| format-table 
}


