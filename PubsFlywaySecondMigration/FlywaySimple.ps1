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

#create an alias for the commandline Flyway, 
Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-7.3.1\flyway.cmd' -Scope local

# project-wide settings
$ProjectFolder = 'S:\work\Github\PubsAndFlyway\PubsFlywaySecondMigration'
$ProjectDescription='A sample project to demonstrate Flyway, using the old Pubs database'

# and here are our project details. The project folder. It works rather like Case-notes
# in that it is read-write. It is passed between tasks.
$DatabaseDetails=@{'pwd'=''; #Always leave blank
                  'uid'='MyUID'#leave blank unless you use credentials
                  ;'Database'='MyDatabase';# fill this in please
                  ;'server'='MyServer';# We need to know the server!
                  ;'port' = $null; #Not normally needed with SQL Server. add if required
                  #set to $null or leave it out if you want to let jdbc detect it 
                  'Project'='Pubs';# the name of the project-needed for saving files
                  'Version'=''; # current version of database - 
                  # leave blank unless you know
                  'Checked'=$false; # has it been checked against a source directory?
                  'Problems'=@()
                  }


# some values, especially server names, have to be escaped when used in file paths.
$Extras=$DatabaseDetails.GetEnumerator()|where {$_.Name -in ('server','Database','Project')}|foreach{
                @{"Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')}
}
$Extras|foreach{$DatabaseDetails+=$_}    
# We've now added the 'escaped' versions of the server, database and project for use in filepaths.


# add a bit of error-checking. Is the project directory there
if (-not (Test-Path "$ProjectFolder"))
   { Write-warning "Sorry, but I couldn't find a project directory at the $ProjectFolder location"}
# ...and is the script directory there?
if (-not (Test-Path "$ProjectFolder\Scripts"))
   { Write-warning "Sorry, but I couldn't find a scripts directory at the $ProjectFolder\Scripts location"}


#now find or elicit the passwords, and get the current version of the database 
$FetchAnyRequiredPasswords.Invoke($DatabaseDetails)# get password if necessary
$GetCurrentVersion.Invoke($DatabaseDetails) #and the current version of the database
if ($DatabaseDetails.Problems.Count -gt 0)
  {Write-Warning "We hit a problem getting the database version: $($DatabaseDetails.Problems)"}

<# now we format the Flyway parameters #>
$MaybePort= "$(if ($DatabaseDetails.port -eq $null) {''} else {":$($DatabaseDetails.port)"})"
if (-not ($DatabaseDetails.uid -in @($null,''))){
$FlyWayArgs =
    @("-url=jdbc:sqlserver://$($DatabaseDetails.Server)$maybePort;databaseName=$($DatabaseDetails.Database)", 
	"-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
	"-user=$($DatabaseDetails.uid)", 
	"-password=$($DatabaseDetails.pwd)")
}
else <# we need to use an integrated security flag in the connection string #>
{
 $FlyWayArgs=
    @("-url=jdbc:sqlserver://$($DatabaseDetails.Server)$maybePort;databaseName=$(
      $DatabaseDetails.Database
      );integratedSecurity=true",
      "-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
}
$FlyWayArgs+= <# the project variables that we reference with placeholders #>
    @("-placeholders.projectDescription=$ProjectDescription",
      "-placeholders.projectName=$($databaseDetails.Project)",
      "-teams") <# the project variables #>

$WhatWasReturned='';
<# if we haven't checked the database to see if it really as at this version #>
if (!($DatabaseDetails.Checked))
{$IsDatabaseIdenticalToSource.Invoke($DatabaseDetails)
}
if ($DatabaseDetails.Problems.Count -gt 0)
  {Write-Warning "We hit a problem checking the database version: $($DatabaseDetails.Problems)"}
<# the 'checked value can be set as $null if the version hasn't already got a 
script directory to check against (like an empty database) . We do the migration anyway,
 but nervously #>
if ($DatabaseDetails.Checked -ne $false) {flyway migrate @FlyWayArgs '-target=latest'}
<# now we need to be certain what version we managed to reach, and then check that we
have scripted out the script folder and the build script #>
# we first line the scripts up as we want to do them. Obviously we need to make sure wnat
# version we have first.
$Invocations=@($GetCurrentVersion,$CreateScriptFoldersIfNecessary,$CreateBuildScriptIfNecessary)
#Now create an object-level script folder and a build script
$Invocations|foreach{if ($DatabaseDetails.Problems.Count -eq 0){ $WhatWasReturned+= $_.Invoke($DatabaseDetails)}}
if ($DatabaseDetails.Problems.Count -gt 0)
  {Write-Error "We hit a problem writing out the scripts $($DatabaseDetails.Problems)"}
$WhatWasReturned






#So lets migrate a version up to 1.1.6
Flyway migrate $FlyWayArgs  '-target=1.1.6'
#check that it worked
flyway info @FlyWayArgs
#and get the version from the database
$GetCurrentVersion.Invoke($DatabaseDetails);$DatabaseDetails.Version
#Now create an object-level script folder and a build script
$Invocations|foreach{ $WhatWasReturned+= $_.Invoke($WithParams)}
Flyway clean  @FlyWayArgs # remove all objects from the database, including baselines
flyway info @FlyWayArgs # check that it has the correct plan for executing the scripts

Flyway migrate $FlyWayArgs '-target=1.1.5'
flyway info @FlywayArgs #check that it all worked
Flyway baseline  @FlywayArgs -baselineVersion='1.1.2' -baselineDescription='First_Build_Script'
flyway info @FlywayArgs
Flyway migrate '-encoding=utf8' @FlywayArgs '-target=1.1.3' # get to whatever level you want
flyway info @FlywayArgs
Flyway migrate '-encoding=utf8' @FlywayArgs '-target=1.1.6' # get to whatever level you want
flyway info @FlywayArgs
Flyway clean @FlywayArgs

@($GetCurrentVersion,$CreateScriptFoldersIfNecessary,$CreateBuildScriptIfNecessary)

($param1=$DatabaseDetails
	@('server', 'database') | foreach{ if ($param1.$_ -eq $null) { write-error "no value for '$($_)'" } }
	#the alias must be set to the path of your installed version of SQL Compare
	$problem = '';
	Set-Alias SQLCmd   'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe' -Scope local
	$Version = 'unknown'
	$query = 'SELECT [version] FROM dbo.flyway_schema_history where success=1'
	$login = if ($param1.uid -ne $null)
	{
		$Myversions = sqlcmd -h -1 -S "$($param1.server)" -d "$($param1.database)" `
							 -Q `"$query`" -U $($param1.uid) -P $($param1.pwd) -u -W
	}
	else
	{ $Myversions = sqlcmd -h -1 -S "$($param1.server)" -d "$($param1.database)" -Q `"$query`" -E -u -W }
	
	
	if (!($?)) { $problem = "could not get version (code $LASTEXITCODE)" }
	elseif (($Myversions -join '-') -like '*Invalid object name*') { $Version = '0.0.0' }
	else
	{
		$Version = ($Myversions | where { $_ -like '*.*.*' } |
			foreach { [version]$_ } |
			Measure-Object -Maximum).Maximum.ToString()
	}
	if ($problem.Length -gt 0) { $param1.Problems += $problem }
	$param1.Version = $version

#So lets migrate a version up to 1.1.6
Flyway migrate $FlyWayArgs  '-target=1.1.6'
#check that it worked
flyway info @FlyWayArgs
#and get the version from the database

$Invocations=@($GetCurrentVersion,$CreateScriptFoldersIfNecessary,$CreateBuildScriptIfNecessary)
#Now create an object-level script folder and a build script
$Invocations|foreach{if ($DatabaseDetails.Problems.Count -eq 0){ $WhatWasReturned+= $_.Invoke($DatabaseDetails)}} 






















<# this routine exports all the data as CSV into a data directory #>
$Param1=$WithParams
$SaveDataIfNotAlreadyDone = {
	Param ($param1)# the parameter is hashtable that contains all the useful values
    @('version','server','database','project')|
                foreach{if($param1.$_ -eq $null){"no value for '$($_)'"}} 
    #the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLDataCompare "${env:ProgramFiles(x86)}\Red Gate\SQL Data Compare 14\sqlDatacompare.exe" -Scope Script
    $MyDataPath = "$($env:USERPROFILE)\Documents\Data\$($param1.EscapedProject)\$($param1.Version)"
	$SArgs = @("/server1:$($param1.server)",
		"/database1:$($param1.database)",
		'/empty2',
		'/force',
        "/export:$MyDataPath",
		"/LogLevel:Warning"	)
	
	if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
	{
		$SArgs += @(
			"/username1:$($param1.uid)",
			"/Password1:$($param1.pwd)"
		)
	}
    if (-not (Test-Path -PathType Container $MyDataPath))
        { # is the path to the scripts directory
	        # not there, so we create the directory 
	        $null = New-Item -ItemType Directory -Force -Path $MyDataPath;
        }
   if (-not (Test-Path -PathType Leaf "$MyDataPath\*.csv"))
        { # is the path to the scripts directory
        SqlDatacompare @SArgs #write out the data as CSV
		if ($?) { "Written data folder for $($param1.Project) $($param1.Version) to $MyDataPath" }
		else
		{ #report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $Sargs | foreach{ $_ }
			"That Went Badly (code $LASTEXITCODE) with paramaters $Arguments."
		}
	}
	else { "This version has already had its data saved in $MyDataPath " }
}
SqlDatacompare /server1:Philf01 /database1:PubsTwo  /server2:Philf01 /database2:PubsOne /username1:PhilFactor /Password1:ismellofpoo4U /username2:PhilFactor /Password2:ismellofpoo4U /Export:C:\Users\andre\Documents\Data\Pubs\1.1.6  /LogLevel:Warning 
dir C:\Users\andre\Documents\Data\Pubs\1.1.6

$env:localappdata%\Red Gate\Logs
/force /export:C:\Users\andre\Documents\Data\Pubs\1.1.6 /LogLevel:Warning 


 $WithParams=@{'pwd'=$pwd;'uid'=$uid;Database=$database;'server'=$server;
                    'Project'=$ProjectName;'Version'=$null}



