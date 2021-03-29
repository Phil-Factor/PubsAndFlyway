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
