
#create an alias for the commandline Flyway, 
#Set-Alias Flyway  'MyPathTo\flyway.cmd' -Scope local
#create an alias for the commandline Flyway, 
Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-7.3.1\flyway.cmd' -Scope local

if (!(test-path  ((Get-alias -Name Flyway ).definition) -PathType Leaf))
   {Write-error "Sorry, but you need a path to the Flyway Commandline"}

$MyProject = 'pubs' #Must fill in the name of the project. This determines where 
#script artefacts are kept
<#
The tasks are in a separate script. It is placed in the same directory as this 
script.
First, find out where we were executed from. Each environment has a different way
of doing it. It all depends how you execute it. If you just past this in, you'll
have to make this the working directory #>
try {
$executablepath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) }
catch{$executablepath = ''} #didn't like that so remove it
if ($executablepath -eq '')
{
    $executablepath = "$(If ($psISE) # null if at the commandline
        { Split-Path -Path $psISE.CurrentFile.FullPath }
        Else { $global:PSScriptRoot })"
}
if ([string]::IsNullOrEmpty($ExecutablePath)){$ExecutablePath=$pwd}
.("$executablepath\DatabaseBuildAndMigrateTasks.ps1")

<# $DatabaseDetails=$DatabaseDetails = 
    @{
    'name' ='TheNameToGiveThisDatabaseAndProject';
    'ProjectFolder' = 'MyPathToTheFlywayFolder\PubsFlywaySecondMigration';
    'ProjectDescription'='However you describe your project';
	'pwd' = ''; #Always leave blank
	'uid' = 'MyUserName'; #leave blank unless you use credentials
	'Database' = 'MyDatabase'; # fill this in please
	'server' = 'MyServer'; # We need to know the server!
	'port' = $null; #Not normally needed with SQL Server. add if required
	#set to $null or leave it out if you want to let jdbc detect it 
	'Project' = $MyProject; # the name of the project-needed for saving files
	'Version' = ''; # current version of database - 
	# leave blank unless you know
     }

#>
$DatabaseDetails = @{
	'name' = 'Arthur'; 'Project' = $MyProject;
}
$Invocations=@(
$FetchOrSaveDetailsOfParameterSet, #save parameters so you can recall them later.
$FetchAnyRequiredPasswords, #passwords are kept in an encrypte4d file in the user area
$GetCurrentVersion, #get the current version so you can save the code report in the right place
$CheckCodeInDatabase, #now look at all the code in the modues (Procs, functions and so on)
$CheckCodeInMigrationFiles, #make sure we've done a code analysis on the files too
$FormatTheBasicFlywayParameters #so we can use flyway
)
$Invocations|foreach{if ($DatabaseDetails.Problems.Count -eq 0)
     { $WhatWasReturned+= $_.Invoke($DatabaseDetails)}
     }
if ($DatabaseDetails.Problems.Count -gt 0) #list out exert error and which task failed
  {$DatabaseDetails.Problems.GetEnumerator()|Foreach{"$($_.Key)---------";$_.Value}|foreach {$_}
  }
$DatabaseDetails.Warnings.CheckCodeInDatabase
	Flyway info  $DatabaseDetails.FlyWayArgs

