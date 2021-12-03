<# this script checks out the code of the current version of the database and 
all the migration file. It lists all the problems in the current database.
Then it runs Flyway Info task on the database #>
$pushVerbosity=$VerbosePreference
$VerbosePreference= 'continue'
#create an alias for the commandline Flyway, 
#Set-Alias Flyway  'MyPathTo\flyway.cmd' -Scope local
#create an alias for the commandline Flyway, 
#Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-8.0.2\flyway.cmd' -Scope local
$FlywayCommand=(Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand) {
    throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0') {
    throw "Your Flyway Version is too outdated to work"
}

if (!(test-path  ((Get-alias -Name Flyway).definition) -PathType Leaf))
{ Write-error "Sorry, but you need a path to the Flyway Commandline" }

$MyProject = 'pubs' #Must fill in the name of the project. This determines where 
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


$pushVerbosity=$VerbosePreference# we will run this in verbose mode to try it out
$VerbosePreference= 'continue'

$Invocations = @(
	$FetchOrSaveDetailsOfParameterSet, #save parameters so you can recall them later.
	$FetchAnyRequiredPasswords, #passwords are kept in an encrypte4d file in the user area
	$GetCurrentVersion, #get the current version so you can save the code report in the right place
	$CheckCodeInDatabase #now look at all the code in the modues (Procs, functions and so on)
)

$OurDetails=@{
  'server'='MyServer'; 
  'Database'='MyDatabase'; 
  'version'='MyVersion';
  'project'='MyProjectName';
  'uid'='MyuserID'; #if necessary!
  'warnings'=@{};'problems'=@{}; 'Locations'=@{}
  'name' = 'TheNameToGiveThisDatabaseAndProject';# only if you want to save it
}


Process-FlywayTasks $OurDetails $Invocations

<# now we print out all the problems with the code reported by Codeguard because it is
in XML format in the file #>
if ($OurDetails.Problems.Count -eq 0)
    {
    [xml]$XmlDocument = Get-Content -Path $OurDetails.Locations.CheckCodeInDatabase
		$warnings = @();
		$warnings += $XmlDocument.root.GetEnumerator() | foreach{
			$name = $_.name.ToString();
			$_.issue
		} |
		select-object  @{ Name = "Object"; Expression = { $name } },
					  code, line, text
		$warnings
	}
#return to our previous verbosity
$VerbosePreference=$pushVerbosity

