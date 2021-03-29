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



<#Purely to test it out, you can execute it this way ...

$DatabaseDetails=@{
 'server'='TheServer'; #the name of your sql server
 'database'='TheDatabase'; #the name of the database
 'version'='TheVersionNumber'; #the version
 'project'='TheProjectName'; #the name of your project
 'uid'='MyUserID' #optional
 'pwd'='MyPassword' #only if you use a uid
 'problems'=@{}; # for reporting
 'warnings'=@{}} # for reporting

$ExecuteTableSmellReport.Invoke($DatabaseDetails)
$DatabaseDetails.problems.ExecuteTableSmellReport



with this system, you can 
access already-saved parameters. The first time that you use this
You might need to provide the parameters in a hashtable like this. 
The system will save the details under the name you give, so 
only do this the once.

$DatabaseDetails = @{
	'name' = 'MyName'; 'server'='MyServer';
    'database'='Database'; uid='myid'; 'Project' = 'pubs';
}
#>
#I've Already saved mine
$DatabaseDetails = @{
	'name' = 'MyDatabase'; 'Project' = 'pubs';
}

<#You can then get the $databaseDetails array filled in by executing
$FetchOrSaveDetailsOfParameterSet
You can inspect, save or edit the JSON parameters
directly at 
$($env:USERPROFILE)\Documents\Deploy\$project and just use them by
starting out with a hashtable with the name of the parameter set
and the name of the flyway project.
 #>


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

