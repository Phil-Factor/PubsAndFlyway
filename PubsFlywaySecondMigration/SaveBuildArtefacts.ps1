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
                  'uid'='MyUserID'#leave blank unless you use credentials
                  ;'Database'='PubsOne';# fill this in please
                  ;'server'='MyServer';# We need to know the server!
                  ;'port' = $null; #Not normally needed with SQL Server. add if required
                  #set to $null or leave it out if you want to let jdbc detect it 
                  'Project'='Pubs';# the name of the project, needed for saving files
                  'Version'=''; # current version of database - 
                  # leave blank unless you know
                  'Checked'=$false; # has it been checked against a source directory?
                  'Problems'=@()
                  }

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
                  'uid'='MyUserID'#leave blank unless you use credentials
                  ;'Database'='PubsOne';# fill this in please
                  ;'server'='MyServer';# We need to know the server!
                  ;'port' = $null; #Not normally needed with SQL Server. add if required
                  #set to $null or leave it out if you want to let jdbc detect it 
                  'Project'='Pubs';# the name of the project, needed for saving files
                  'Version'=''; # current version of database - 
                  # leave blank unless you know
                  'Checked'=$false; # has it been checked against a source directory?
                  'Problems'=@()
                  'Warnings'=@()
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
  {
  Write-Warning "We hit a problem getting the credentials: $(
    $DatabaseDetails.Problems|Foreach{$_.issues})"
    }

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
if (!($DatabaseDetails.Checked -eq $true))
{
$IsDatabaseIdenticalToSource.Invoke($DatabaseDetails)
$DatabaseDetails.Warnings|where Name -like 'IsDatabaseIdenticalToSource'|
  Foreach{$_.issues}|Foreach{write-warning $_}
}
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
  {
  $ourProblems=$DatabaseDetails.Problems | foreach{$TheName=$_.name;$_.Issues}|foreach{"$($TheName): $_"}
  Write-warning "We hit a problem with $($ourProblems -join '-')"
  }
if ($DatabaseDetails.Warnings.Count -gt 0)
  {
  $ourWarnings=$DatabaseDetails.Warnings | foreach{$TheName=$_.name;$_.Issues}|foreach{"$($TheName): $_"}
  Write-warning "When using $($ourWarnings -join '-')"
  } 
