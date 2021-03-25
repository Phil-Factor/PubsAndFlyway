$MyProject='pubs' #Must fill in the name of the project. This determines where 
 #script artefacts are kept
<#
The tasks are in a separate script. It is placed in the same directory as this 
script.
First, find out where we were executed from. Each environment has a different way
of doing it. It all depends how you execute it. If you just past this in, you'll
have to make this the working directory #>
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

<#
# so we define our project-wide settings
$DatabaseDetails = @{
    'ProjectFolder' = 'MyPathToTheFlywayFolder\PubsFlywaySecondMigration';
    'ProjectDescription'='A sample project to demonstrate Flyway, using the old Pubs database';
	'pwd' = ''; #Always leave blank
	'uid' = 'MyUserName'; #leave blank unless you use credentials
	'Database' = 'MyDatabase'; # fill this in please
	'server' = 'MyServer'; # We need to know the server!
	'port' = $null; #Not normally needed with SQL Server. add if required
	#set to $null or leave it out if you want to let jdbc detect it 
	'Project' = $MyProject; # the name of the project-needed for saving files
	'Version' = ''; # current version of database - 
	# leave blank unless you know
	'Checked' = $false; # has it been checked against a source directory?
	'Problems' = @();
	'Warnings' = @()
     }
#>
$DatabaseDetails=@{
    'name' = 'Arthur';'Project' = $MyProject;}

@($FetchOrSaveDetailsOfParameterSet,
$FetchAnyRequiredPasswords,
$FormatTheBasicFlywayParameters
)| foreach {
   if ($DatabaseDetails.Problems.Count -eq 0) 
    {$_.Invoke($DatabaseDetails) } }

if ($DatabaseDetails.Problems.Count -eq 0) 
    {Flyway clear  $DatabaseDetails.FlyWayArgs}
$WhatWasReturned = '';
 <# just add, comment in, or comment out anything you want or not #>
$Invocations = @(
# $FetchOrSaveDetailsOfParameterSet,
<#This adds escaped versions of the project name, server and database. It also 
picks up the saved parameters from file if you just provide a name and a project,
or saves all the parameters to file if you want to do that using the name you provide 
but if you don't provide a name than it does nothing except check that you have escapes #>
#$FetchAnyRequiredPasswords, #picks up a password for the database if you've provided a UID
$GetCurrentVersion, #checks the database and gets the current version number 
$CheckCodeInDatabase, #checks the code in the database for issues if this hasn't been done yet
 $IsDatabaseIdenticalToSource,# if it can, checks to see if the database really is what you think
 $CreateBuildScriptIfNecessary, #writes out a build script if there isn't one for this version
 $CreateScriptFoldersIfNecessary #writes out a source folder with an object level script if absent
 )
$Invocations | foreach{ if ($DatabaseDetails.Problems.Count -eq 0) 
    {$_.Invoke($DatabaseDetails) } }
$OurProblems = ''

if ($DatabaseDetails.Problems.Count -gt 0)
{
	$ourProblems = $DatabaseDetails.Problems | foreach{ $TheName = $_.name; $_.Issues } | foreach{ "$($TheName): $_" }
	Write-warning "We hit a problem with $($ourProblems -join '-')"
}
if ($DatabaseDetails.Warnings.Count -gt 0)
{
	$ourwarnings = $DatabaseDetails.Warnings | foreach{ $TheName = $_.name; $_.Issues } | foreach{ "$($TheName): $_" }
	Write-output "We had a Warning with $($ourWarnings -join "`n")"
}

