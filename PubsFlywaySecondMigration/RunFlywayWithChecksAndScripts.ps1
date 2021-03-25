
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

<#
# so we define our project-wide settings
$DatabaseDetails = @{
    'name' ='TheNameToGiveThisDatabaseAndProject';
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
     }
#>
$DatabaseDetails = @{
	'name' = 'MyDatabase'; 'Project' = $MyProject;
}

<# first grab all those boring details from disk for the project and database #>  
# we line out our tasks in an array 
@($FetchOrSaveDetailsOfParameterSet, #add escaped names, pick up details by name and project
	$FetchAnyRequiredPasswords, #get any passwords needed from secure storage
	$FormatTheBasicFlywayParameters, #so you can run flyway
    $CheckCodeInMigrationFiles  # check that all migration files have had a report
) | foreach { #we execute these tasks in turn 
	if ($DatabaseDetails.Problems.Count -eq 0)
	{ $_.Invoke($DatabaseDetails) }
}
<# at this point we are ready to do all the standard tasks. For this demonstration, we'll
clean our test database #>
if ($DatabaseDetails.Problems.Count -eq 0)
{
	Flyway clean  $DatabaseDetails.FlyWayArgs
}
<# now we will upgrade one file at a time and test out all our tasks as we go. We should
end up with a scripts directory with source and build scripts. 
The second time we run this, the drift check will kick in on every version because in each 
case we have a scripts directory. You can try stopping after every version and tampering
with the database to see whether it picks up your changes #> 
# list out all the existing versions in order
dir "$($DatabaseDetails.projectFolder)/scripts/V*.sql" |
foreach{ [version]($_.Name -replace 'V(?<Version>[.\d]+).+', '${Version}') } |
Sort-Object | foreach{
	if ($DatabaseDetails.Problems.Count -eq 0)
	{
		$Invocations = @(
			$GetCurrentVersion, #checks the database and gets the current version number 
			#$CheckCodeInDatabase, #checks the code in the database for issues if this hasn't been done yet
			$IsDatabaseIdenticalToSource, # if it can, checks to see if the database really is what you think
		)
		$Invocations | foreach{
			if ($DatabaseDetails.Problems.Count -eq 0)
			{ Write-Verbose "Executing from line $($_.startposition.StartLine)"; $_.Invoke($DatabaseDetails) }
		}
		Flyway migrate "-target=$($_.ToString())"  $DatabaseDetails.FlyWayArgs
		$Invocations = @(
			$GetCurrentVersion, #checks the database and gets the current version number 
			$CreateBuildScriptIfNecessary, #writes out a build script if there isn't one for this version
			$CreateScriptFoldersIfNecessary #writes out a source folder with an object level script if absent
		)
		$Invocations | foreach{
			if ($DatabaseDetails.Problems.Count -eq 0)
			{ Write-Verbose "Executing from line $($_.startposition.StartLine)"; $_.Invoke($DatabaseDetails) }
		}
	}
}
#list out evey problem with where it happened
if ($DatabaseDetails.Problems.Count -gt 0) #list out exert error and which task failed
  {$DatabaseDetails.Problems.GetEnumerator()|Foreach{"$($_.Key)---------";$_.Value}|foreach {$_}
  }
# and list out every warning.
if ($DatabaseDetails.Warnings.Count -gt 0) #list out our warnings
  {$DatabaseDetails.Warnings.GetEnumerator()|Foreach{"$($_.Key)---------";$_.Value}|foreach {$_}
  }


  $DatabaseDetails = @{
	'name' = 'MyDatabase'; 'Project' = $MyProject;
} 
#You can then fill in the $databaseDetails array by executing
$FetchOrSaveDetailsOfParameterSet.invoke($DatabaseDetails)

