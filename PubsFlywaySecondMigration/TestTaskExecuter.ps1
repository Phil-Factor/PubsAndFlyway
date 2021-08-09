<# This script uses the task executer Process-FlywayTasks to do a table-smell report
on the current version of the database #>
try
{
	$executablepath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
}
catch { $executablepath = '' } #didn't like that so remove it
if ($executablepath -eq '')
{
	$executablepath = "$(If ($psISE) # null if at the commandline
		{ Split-Path -Path $psISE.CurrentFile.FullPath }
		Else { $global:PSScriptRoot })"
}
if ([string]::IsNullOrEmpty($ExecutablePath)) { $ExecutablePath = $pwd }
.("$executablepath\DatabaseBuildAndMigrateTasks.ps1")
$DatabaseDetails=@{
 'server'='PentlowMillServ'; #the name of your sql server
 'database'='PubsTwo'; #the name of the database
 'version'=''; #the version
 'ProjectFolder'='S:\work\github\PubsAndFlyway\PubsFlywaySecondMigration\Scripts'
 'project'='Pubs'; #the name of your project
 'uid'='PhilFactor'; #optional
 'locations'=@{}; # for reporting file locations used
 'problems'=@{}; # for reporting any problems
 'warnings'=@{}} # for reporting any warnings

$DatabaseDetails.problems=@{}
Process-FlywayTasks $DatabaseDetails  @(
$FetchOrSaveDetailsOfParameterSet, # get the details, initialise
$FetchAnyRequiredPasswords, #deal with passwords
$GetCurrentVersion, #access the database to work out the current version
$ExecuteTableSmellReport)

$Report=$DatabaseDetails.Locations.ExecuteTableSmellReport
if ( $Report-ne $null)
    {$TheReport=Get-Content -Path $Report -raw|ConvertFrom-JSON
    $TheReport|foreach{$Table=$_.TableName; $_.Problems }|
         Select @{label="Table";expression={$table}},
          @{label="Problem";expression={$_.problem}}
    }
