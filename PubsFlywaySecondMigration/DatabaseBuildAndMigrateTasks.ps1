﻿<#

These are a collection of script blocks that are designed to run with Flyway
- either in the community edition or with Teams. They allow you to maintain
backups or scripts for each version and make a Flyway a full participant
in any source control system in use, even to the point of providing an 
object-level source to allow the eveolution of individual tables to be tracked

A simple database that is really nothing more than a grown-up spreadsheet will 
not need any of this fancy stuff. It becomes increasingly important as the
database grows into a team effort. The facilities cover automatic code reviews,
source control, and change tracking. It provides build scripts that are, I
believe, essential to successful branching and merging, and for databases such
as MySQL that do not roll-back DDL changes in failed transactions. Some of 
these utilities are there primarily to show how to run exteranal programs,
or to save the results of a SQL Call as a JSON file or other result. I have 
examples of SQL Code executed from a variable containing a query,  and from 
a file. 

They share a common data object (it
is actually a hashTable) and which can be batched up into an array
and processed one by one. Some of them are utility chores such as extracting
passwords from a relatively safe place, or fetching prepared parameters. There
is one that merely formats the data. They are able to write errors or status
to the data object. The hashtable is passed by reference. One has to be cautious
with this because alterations to the hashtable can result in powerShell holding
a copy instead. 

As well as being run in a series, they can be used individually. If one of them
needs maintenance, it is very easy to pull it apart and run it interactively.

The reason for using this design was to make it easy to choose what gets run 
and in what order. 


 
$CreateBuildScriptIfNecessary 
a script block that produces a build script from a database, using SQL Compare.

$CheckCodeInDatabase 
This scriptblock checks the code in the database for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the current database, not the scripts

$CheckCodeInMigrationFiles
This scriptblock checks the code in the migration files for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the scripts not the current database.


$CreateScriptFoldersIfNecessary:
this task checks to see if a Source folder already exists for this version of the
database and, if not, it will create one and fill it with subdirectories for each
type of object. A tables folder will, for example, have a file for every table each
containing a build script to create that object. When this exists, it allows SQL Compare
to do comparisons and check that a version has not drifted. It saves the Source folder
as a subfolder for the supplied version, so it needs $GetCurrentVersion to have been
run beforehand in the chain of tasks.

$CreateBuildScriptIfNecessary: 
produces a build script from the database, using SQL Compare. It saves the build script
in the Scripts folder, as a subfolder for the supplied version, so it needs
$GetCurrentVersion to have been run beforehand in the chain of tasks.


$ExecuteTableSmellReport
This scriptblock executes SQL that produces a report in XML or JSON from the database
that alerts you to tables that may have issues

$ExecuteTableDocumentationReport
 This places in a report a json report of the documentation of every table and its
columns. If you add or change tables, this can be subsequently used to update the 
AfterMigrate callback script
for the documentation. 

$FetchOrSaveDetailsOfParameterSet
This checks over the scriptblock 
and project. it allows you to save and load the shared parameters for all these 
scriptblocks under a name you give it. you'd choose a different name for each
database within a project, but make them unique across projects. If the parameters
have the name defined but vital stuff missing, it fills in from the last remembered 
version. If it has the name and the vital stuff then it assumes that you want to 
save it. If no name then it ignores.

$FetchAnyRequiredPasswords 
This checks the hash table to see if there is a username without a password. 
If so, the task asks for it in a query window and stores it, encrypted, in 
the user area it. If the user already has the password stored for this username
and database, it uses it.

$ExecuteTableSmellReport
This scriptblock executes SQL that produces a report in XML or JSON from the database


$FormatTheBasicFlywayParameters
This provides the flyway parameters. This is here bvecause it is useful for the 
community flyway when you wish to do further Flyway actions after doing any
scripting and code checks.

$GetCurrentVersion 
This contacts the database and determines its current version by interrogating
the flyway_schema_history data table in the database. It merely finds the highest
version number recorded as being successfully used. If it is an empty database,
or there is just no Flyway data, then it returns a version of 0.0.0.

$IsDatabaseIdenticalToSource: 
This uses SQL Compare to check that a version of a database is correct and hasn't been
changed. To do this, the $CreateScriptFoldersIfNecessary task must have been run
first. It compares the database to the associated source folder, for that version,
and returns, in the hash table, the comparison equal to true if it was the same,
or false if there has been drift, with a list of objects that have changed. If
the comparison returns $null, then it means there has been an error. To access
the right source folder for this database version, it needs $GetCurrentVersion
to have been run beforehand in the chain of tasks




 #>
#we use SQLCMD to access SQL Server
$SQLCmdAlias = "$($env:ProgramFiles)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe"
#We use SQL Code Guard for code analysis.
$CodeGuardAlias= "${env:ProgramFiles(x86)}\SQLCodeGuard\SqlCodeGuard30.Cmd.exe"
# We use SQL Compare to compare build script with database
# and for generating scripts.
$SQLCompareAlias= "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 13\sqlcompare.exe"
#where we want to store reports, the sub directories from the user area.
$ReportLocation='Documents\GitHub\'# part of path from user area to project artefacts folder location 



<# This scriptblock allows you to save and load the shared parameters for all these 
scriptblocks under a name you give it. you'd choose a different name for each database
within a project, but make them unique across projects 
If the parameters have the name defined but vital stuff missing, it fills 
in from the last remembered version. If it has the name and the vital stuff then it assumes
you want to save it. If no name then it ignores. 
#>
$FetchOrSaveDetailsOfParameterSet = {
	Param ($param1) # $FetchOrSaveDetailsOfParameterSet: (Don't delete this)
	$Param1.'Problems' = @{ };
	$Param1.'Warnings' = @{ };
	$Param1.'Locations' = @{ };
	$problems = @();
	if ($Param1.name -ne $null -and $Param1.project -ne $null)
	{
		# define where we store our secret project details
		$StoredParameters = "$($env:USERPROFILE)\Documents\Deploy\$(($param1.Project).Split([IO.Path]::GetInvalidFileNameChars()) -join '_')";
		$ParametersFilename = 'AllParameters.json';
		$TheLocation = "$StoredParameters\$($Param1.Name)-$ParametersFilename"
	}
	$VariablesWeWant = @(
			'server', 'uid', 'port', 'project', 'database', 'projectFolder', 'projectDescription'
		);	
	if ($Param1.name -ne $null -and $Param1.project -ne $null -and $Param1.Server -eq $null -and $Param1.Database -eq $null)
	{
		# we don't want to keep passwords unencrypted and we don't want any of the transitory
		# variables that provide state (warnings, error, version number and so on)
		# If the directory doesn't exist then create it
		if (!(test-path -Path $StoredParameters -PathType Container))
		{ $null = New-Item -Path $StoredParameters -ItemType "directory" -Force }
		#if the file already exists then read it in.
		
		if (test-path $TheLocation -PathType leaf)
		{
			# so we read in all the details
			try
			{
				$JSONcontents = Get-Content -Path $TheLocation -Raw
				$TheActualParameters = $JSONcontents | ConvertFrom-json
			}
			catch
			{
				$Problems += "Cannot read file $TheLocation because it has unescaped content"
			}
			if ($problems.count -eq 0)
			{
				$TheActualParameters.psobject.properties |
				Foreach { if ($_.Name -in $VariablesWeWant) { $param1[$_.Name] = $_.Value } }
				write-verbose "fetched details from $TheLocation"
				$VariablesWeWant | where { $_ -notin @('port', 'ProjectFolder', 'projectDescription') } |
				foreach {
					if ($param1.$_ -eq $null) { $Problems += "missing a value for $($_)" }
				}
			}
		}
		else
		{
			$Problems += "Could not find project file $TheLocation"
		}
	}
	#if the user wants to save or resave they'll the name AND include both the the server and database
	elseif ($Param1.Name -ne $null -and $Param1.Server -ne $null -and $Param1.Database -ne $null)
	{
		$RememberedHashTable = @{ }
		$VariablesWeWant | foreach{ $RememberedHashTable.$_ = $param1.$_ }
		$RememberedHashTable | ConvertTo-json |
		out-file -FilePath $TheLocation -Force
		"Saved details to $TheLocation"
	}
	# This section is to check for values that really should be there and if
	# necessary, insert them.
	# some values, especially server names, have to be escaped when used in file paths.
	<#if ($Param1.'Escapedserver' -eq $null)
	{
		"Escaping"
		$EscapedValues = @()
		$EscapedValues += $Param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-' }
		}
		$EscapedValues | foreach{ $_.GetEnumerator() } | foreach{ $param1[$_.Name] = $_.Value }
	} #>
	if ($Param1.'Checked' -eq $null) { $Param1.'Checked' = $false; }
	# has it been checked against a source directory?
	@('server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	if ($TheLocation -ne $null)
	{ $Param1.Locations.'FetchOrSaveDetailsOfParameterSet' = $TheLocation; }
	if ($problems.Count -gt 0)
	{ $Param1.Problems.'FetchOrSaveDetailsOfParameterSet' += $problems; }
}

<# now we format the Flyway parameters #>
#>

$FormatTheBasicFlywayParameters = {
	Param ($param1) # $FormatTheBasicFlywayParameters (Don't delete this)
	$problems = @();
	@('server', 'database', 'projectFolder') |
	foreach{ if ($param1.$_ -in @($null,'')) { $problems += "no value for '$($_)'" } }
	
	$MaybePort = "$(if ([string]::IsNullOrEmpty($param1.port)) { '' }
		else { ":$($param1.port)" })"
	if (!([string]::IsNullOrEmpty($param1.uid)))
	{
		if ($param1.pwd -eq $null) { $problems += "no password provided for $($($param1.uid))" }
		$FlyWayArgs =
		@("-url=jdbc:sqlserver://$($param1.Server)$maybePort;databaseName=$($param1.Database)",
			"-locations=filesystem:$($Param1.ProjectFolder)\Scripts", <# the migration folder #>
			"-user=$($param1.uid)",
			"-password=$($param1.pwd)")
	}
	else <# we need to use an integrated security flag in the connection string #>
	{
		$FlyWayArgs =
		@("-url=jdbc:sqlserver://$($param1.Server)$maybePort;databaseName=$(
				$param1.Database
			);integratedSecurity=true",
			"-locations=filesystem:$($param1.ProjectFolder)\Scripts")<# the migration folder #>
	}
	
	$FlyWayArgs += <# the project variables that we reference with placeholders #>
	@("-placeholders.projectDescription=$($param1.ProjectDescription)",
		"-placeholders.projectName=$($param1.Project)",
		"-community") <# Change this if using teams!! #>
	$Param1.FlywayArgs = $FlyWayArgs
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'FormatTheBasicFlywayParameters' += $problems;
	}
}



<# This scriptblock looks to see if we have the passwords stored for this userid and daytabase
if not we ask for it and store it encrypted in the user area
 #>

$FetchAnyRequiredPasswords = {
	Param ($param1) # $FetchAnyRequiredPasswords (Don't delete this)
	$problems = @()
	@('server') |
	foreach{ if ($param1.$_ -in @($null,'')) { $problem = "no value for '$($_)'" } }
	# some values, especially server names, have to be escaped when used in file paths.
	<# this prevents the array being updated
    if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-' }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
    $escapedServer=($Param1.server.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	# now we get the password if necessary
	if (!([string]::IsNullOrEmpty($param1.uid))) #then it is using SQL Server Credentials
	{
		# we see if we've got these stored already
		$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($param1.uid)-$($escapedServer).xml"
		# test to see if we know about the password in a secure string stored in the user area
		if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
		{
			#has already got this set for this login so fetch it
			$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
		}
		else #then we have to ask the user for it (once only)
		{
			# hasn't got this set for this login
			$SqlCredentials = get-credential -Credential $param1.uid
			# Save in the user area 
			$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
		}

		$param1.Uid = $SqlCredentials.UserName;
		$param1.Pwd = $SqlCredentials.GetNetworkCredential().password
	}

if ($problems.Count -gt 0)
	{
		$Param1.Problems.'FetchAnyRequiredPasswords' += $problems;
	}
}

<#This scriptblock checks the code in the database for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the current database, not the scripts
 #>
$CheckCodeInDatabase = {
	Param ($param1) # $CheckCodeInDatabase - (Don't delete this)
	#you must set this value correctly before starting.
	Set-Alias CodeGuard $CodeGuardAlias -Scope local
	$Problems = @(); #our local problem counter
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }
	<#if ($param1.Escapedserver -eq $null) #double-check that escapedValues are in place
	{
		#we need this to wotk out the location for the report
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{
				"Escaped$($_.Name)" = (
					$_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
			}
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	#check that all the values we need are in the hashtable
	@('server', 'Database', 'version', 'Project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	#now we create the parameters for CodeGuard.
    $escapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = "$($env:USERPROFILE)\$ReportLocation$(
		$escapedProject)\$($param1.Version)\Reports"
	if ($MyDatabasePath -like '*\\*'){ } { $Problems += "created an illegal path '$MyDatabasePath'" }
    $Arguments = @{
		server = $($param1.server) #The server name to connect
		Database = $($param1.database) #The database name to analyze
		outfile = "$MyDatabasePath\codeAnalysis.xml" <#
        The file name in which to store the analysis xml report#>
		#exclude='BP007;DEP004;ST001' 
		#A semicolon separated list of rule codes to exclude
		include = 'all' #A semicolon separated list of rule codes to include
	}
	#add the arguments for credentials where necessary
	if (!([string]::IsNullOrEmpty($param1.uid)))
	{
		$Arguments += @{
			User = $($param1.uid)
			Password = $($param1.pwd)
		}
	}
	# we need to make sure tha path is there
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	<# we only do the analysis if it hasn't already been done for this version,
    and we've hit no problems #>
	if (($problems.Count -eq 0) -and (-not (
				Test-Path -PathType leaf  "$MyDatabasePath\codeAnalysis.xml")))
	{
		$result = codeguard @Arguments; #execute the command-line Codeguard.
		if ($? -or $LASTEXITCODE -eq 1)
		{
			"Written Code analysis for $($param1.Project) $($param1.Version
			) to $MyDatabasePath\codeAnalysis.xml"
		}
		else
		{
			<#report a problem and send back the args for diagnosis 
            (hint, only for script development) #>
			$Args = '';
			$Args += $Arguments |
			foreach{ "$($_.Name)=$($_.Value)" }
			$problems += "CodeGuard responded '$result' with error code $LASTEXITCODE when used with parameters $Args."
		}
		#$Problems += $result | where { $_ -like '*error*' }
	}
	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInDatabase! ";
		$Param1.Problems.'CheckCodeInDatabase' += $problems;
	}
	
	$Param1.Locations.'CheckCodeInDatabase' = "$MyDatabasePath\codeAnalysis.xml";

	
}


<#This scriptblock checks the code in the migration files for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the scripts not the current database.
$OurDetails=@{
  'project'='MyProjectName';
  '
  'warnings'=@{};'problems'=@{};}
$CheckCodeInMigrationFiles.Invoke($OurDetails)

 $Details=@{
'Project'='publications';                                                                                                                                                                                                          
'Warnings'=@{};                                                                                                                                                                                                            
'Problems'=@{};                                                                                                                                                                                                            
'projectFolder'='YourPathTo\PubsAndFlyway\PubsFlywaySecondMigration'                                                                                                                                                        
}
$param1=$details
$CheckCodeInMigrationFiles.Invoke($Details) #>

$CheckCodeInMigrationFiles = {
	Param ($param1) # $CheckCodeInMigrationFiles - (Don't delete this)
	#you must set this value correctly before starting.
	Set-Alias CodeGuard $CodeGuardAlias -Scope local
	$Problems = @(); #our local problem counter
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }
	#check that all the values we need are in the hashtable
	@('ProjectFolder') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
    $escapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	dir "$($param1.projectFolder)\V*.sql" | foreach{
		$Thepath = $_.FullName;
		$TheFile = $_.Name
		$Theversion = ($_.Name -replace 'V(?<Version>[.\d]+).+', '${Version}')
		#now we create the parameters for CodeGuard.
		$MyVersionReportPath = "$($env:USERPROFILE)\$ReportLocation$(
			$EscapedProject)\$TheVersion\Reports"
		$Arguments = @{
			source = $ThePath
			outfile = "$MyVersionReportPath\FilecodeAnalysis.xml" <#
            The file name in which to store the analysis xml report#>
			#exclude='BP007;DEP004;ST001' 
			#A semicolon separated list of rule codes to exclude
			include = 'all' #A semicolon separated list of rule codes to include
		}
		# we need to make sure tha path is there
		if (-not (Test-Path -PathType Container $MyVersionReportPath))
		{
			# does the path to the reports directory exist?
			# not there, so we create the directory 
			$null = New-Item -ItemType Directory -Force $MyVersionReportPath;
		}
	    <# we only do the analysis if it hasn't already been done for this version,
        and we've hit no problems #>
		if (($problems.Count -eq 0) -and (-not (
					Test-Path -PathType leaf  "$MyVersionReportPath\FilecodeAnalysis.xml")))
		{
			$result = codeguard @Arguments; #execute the command-line Codeguard.
			if ($? -or $LASTEXITCODE -eq 1)
			{
				Write-Verbose  "Written file Code analysis for $TheFile for $($param1.Project) project) to $MyVersionReportPath\FilecodeAnalysis.xml"
			}
			else
			{
			    <#report a problem and send back the args for diagnosis 
                (hint, only for script development) #>
				$Args = '';
				$Args += $Arguments.GetEnumerator() |
				foreach{ "$($_.Name)=$($_.Value)" }
				$problems += "CodeGuard responded '$result' with error code $LASTEXITCODE when used with parameters $Args."
			}
			#$Problems += $result | where { $_ -like '*error*' }
		}
	}
	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInMigrationFiles! ";
		$Param1.Problems.'CheckCodeInMigrationFiles' += $problems;
	}

    $Param1.Locations.'CheckCodeInMigrationFiles' = "$MyVersionReportPath\FilecodeAnalysis.xml"; 
		
}


<#This scriptblock gets the current version of a flyway_schema_history data from the 
table in the database. if there is no Flyway Data, then it returns a version of 0.0.0
 #>
$GetCurrentVersion = {
	Param ($param1) # $GetCurrentVersion parameter is a hashtable 
 
	@('server', 'database') | foreach{ if ($param1.$_ -in @($null,'')) { write-error "no value for '$($_)'" } }
   <#
   if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCmd   $SQLCmdAlias -Scope local
	$Problems = @();
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCMD is not set correctly yet' }	$Version = 'unknown'
	$query = 'SELECT [version] FROM dbo.flyway_schema_history where success=1'
	$login = if ($param1.uid -ne $null)
	{
		$Myversions = sqlcmd -h -1 -S "$($param1.server)" -d "$($param1.database)" `
							 -Q `"$query`" -U $($param1.uid) -P $($param1.pwd) -u -W
		$arguments = "$($param1.server) -d $($param1.database) -U $($param1.uid) -P $($param1.pwd)"
	}
	else
	{
		$Myversions = sqlcmd -h -1 -S "$($param1.server)" -d "$($param1.database)" -Q `"$query`" -E -u -W
		$arguments = "$($param1.server) -d $($param1.database)"
	}
	if (!($?) -or ($Myversions -eq $null))
	{
		#report a problem and send back the args for diagnosis (hint, only for script development)
		$Problems += "sqlcmd failed with code $LASTEXITCODE, $Myversions, with parameters $arguments"
	}
	elseif (($Myversions -join '-') -like '*Invalid object name*')
	{ $Version = '0.0.0' }
	else
	{
		$Version = ($Myversions | where { $_ -like '*.*.*' } |
			foreach { [version]$_ } |
			Measure-Object -Maximum).Maximum.ToString()
	}
	if ($problems.Count -gt 0)
	{
		Write-error "$problems happened!";
		$Param1.Problems.'GetCurrentVersion' += $problems;
	}
	$param1.Version = $version
}

<# This uses SQL Compare to check that a version of a database is correct and hasn't been changed.
It returns comparison equal to true if it was the same or false if there has been drift, 
with a list of objects that have changed. if the comparison returns $null, then it means there 
has been an error #>

$IsDatabaseIdenticalToSource = {
	Param ($param1) # $IsDatabaseIdenticalToSource (Don't delete this)
	$problems = @();
	$warnings = @();
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $problems += "no value for '$($_)'" } }
	<#if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	if ($param1.Version -eq '0.0.0') { $identical = $null; $warnings += "Cannot compare an empty database" }
	$GoodVersion = try { $null = [Version]$param1.Version; $true }
	catch { $false }
	if (-not ($goodVersion))
	{ $problems += "Bad version number '$($param1.Version)'" }
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	if ($problems.Count -eq 0)
	{
		
        $escapedProject=($Param1.Project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
        #the database scripts path would be up to you to define, of course
		$MyDatabasePath = "$($env:USERPROFILE)\$ReportLocation$($EscapedProject)\$($param1.Version)\Source"
		$Args = @(# we create an array in order to splat the parameters. With many command-line apps you
			# can use a hash-table 
			"/Scripts1:$MyDatabasePath"
			"/server2:$($param1.server)",
			"/database2:$($param1.database)",
			"/Assertidentical",
			"/force",
			'/exclude:ExtendedProperty' #trivial
			"/LogLevel:Warning"
		)
		if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
		{
			$Args += @(
				"/username2:$($param1.uid)",
				"/Password2:$($param1.pwd)"
			)
		}
	}
	if ($problems.Count -eq 0)
	{
		if (Test-Path -PathType Container $MyDatabasePath) #if it does already exist
		{
			Sqlcompare @Args #simply check that the two are identical
			if ($LASTEXITCODE -eq 0) { $identical = $true; "Database Identical to source" }
			elseif ($LASTEXITCODE -eq 79) { $identical = $False; "Database Different to source" }
			else
			{
				#report a problem and send back the args for diagnosis (hint, only for script development)
				$Arguments = ''; $identical = $null;
				$Arguments += $args | foreach{ $_ }
				$problems += "That Went Badly (code $LASTEXITCODE) with paramaters $Arguments."
			}
		}
		else
		{
			$identical = $null;
			$Warnings = "source folder '$MyDatabasePath' did not exist so can't check"
		}
		
	}
	$param1.Checked = $identical
	if ($problems.Count -gt 0)
	{ $Param1.Problems.'IsDatabaseIdenticalToSource' += $problems; }
	if ($warnings.Count -gt 0)
	{ $Param1.Warnings.'IsDatabaseIdenticalToSource' += $Warnings; }
}

<#this routine checks to see if a script folder already exists for this version
of the database and, if not, it will create one and fill it with subdirectories
for each type of object. A tables folder will, for example, have a file for every table
each containing a  build script to create that object.
When this exists, it allows SQL Compare to do comparisons and check that a version has not
drifted.#>

$CreateScriptFoldersIfNecessary = {
	Param ($param1) # $CreateScriptFoldersIfNecessary 
	$Problem = @(); #We check that it contains the keys for the values that we need 
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -eq $null) { $problems += "no key for the '$($_)'" } }
	<#if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
    $EscapedProject=($Param1.Project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = "$($env:USERPROFILE)\$ReportLocation$($EscapedProject)\$($param1.Version)\Source"
	$Args = @(
		"/server1:$($param1.server)",
		"/database1:$($param1.database)",
		"/Makescripts:$($MyDatabasePath)", #special command to make a scripts directory
		"/force",
		"/LogLevel:Warning"
	)
	
	if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
	{
		$Args += @(
			"/username1:$($param1.uid)",
			"/Password1:$($param1.pwd)"
		)
	}
	if ($problems.Count -eq 0 -and (!(Test-Path -PathType Container $MyDatabasePath))) #if it doesn't already erxist
	{
		Sqlcompare @Args #write an object-level  script folder that represents the vesion of the database
		if ($?) { "Written script folder for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
		else
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $args | foreach{ $_ }
			$problems += "SQL Compare responded with error code $LASTEXITCODE when used with paramaters $Arguments."
		}
		if ($problems.count -gt 0)
		{ $param1.Problems += @{ 'Name' = 'CreateScriptFoldersIfNecessary'; Issues = $problems } }
	}
	else { "This version is already scripted in $MyDatabasePath " }
}

<# a script block that produces a build script from a database, using SQL Compare. #>

$CreateBuildScriptIfNecessary = {
	Param ($param1) # $CreateBuildScriptIfNecessary (Don't delete this) 
	$problems = @();
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	<#if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
    $EscapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = "$($env:USERPROFILE)\$ReportLocation$($EscapedProject)\$($param1.Version)\Scripts"
	$Args = @(# we create an array in order to splat the parameters. With many command-line apps you
		# can use a hash-table 
		"/server1:$($param1.server)",
		"/database1:$($param1.database)",
		"/exclude:table:flyway_schema_history",
		"/empty2",
		"/force", # 
		"/options:NoTransactions,NoErrorHandling", # so that we can use the script with Flyway more easily
		"/LogLevel:Warning",
		"/ScriptFile:$MyDatabasePath\V$($param1.Version)__Build.sql"
	)
	
	if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
	{
		$Args += @(
			"/username1:$($param1.uid)",
			"/Password1:$($param1.pwd)"
		)
	}
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# is the path to the scripts directory
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	
	
	if (-not (Test-Path -PathType Leaf "$MyDatabasePath\V$($param1.Version)__Build.sql"))
	{
		# if it is done already, then why bother? (delete it if you need a re-run for some reason 	
		Sqlcompare @Args #run SQL Compare with splatted arguments
		if ($?) { "Written build script for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
		else # if no errors then simple message, otherwise....
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $args | foreach{ $_ }
			$Problems += "SQLCompare Went badly. (code $LASTEXITCODE) with paramaters $Arguments."
		}
		if ($problems.count -gt 0)
		{ $Param1.Problems.'CreateBuildScriptIfNecessary' += $problems; }
	}
	else { "This version '$($param1.Version)' already has a build script at $MyDatabasePath " }
	
}
<#This scriptblock executes SQL that produces a report in XML or JSON from the database
#>

$ExecuteTableSmellReport = {
	Param ($param1) # $ExecuteTableSmellReport - parameter is a hashtable 
	$problems = @()
	@('server', 'database', 'version', 'project') | foreach{
		if ($param1.$_ -eq $null)
		{ write-error "no value for '$($_)'" }
	}
	<#if ($param1.EscapedProject -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
    $EscapedProject=($Param1.Project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = "$($env:USERPROFILE)\$ReportLocation$(
		$EscapedProject)\$($param1.Version)\Reports"
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	$MyOutputReport = "$MyDatabasePath\TableIssues.JSON"
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCmd   $SQLCmdAlias  -Scope local
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCMD is not set correctly yet' }
	$query = @'
SET NOCOUNT ON
/**
summary:   >
 This query finds the following table smells
 1/ is a Wide table (set this to what you consider to be wide)
 2/ is a Heap
 3/ is an undocumented table
 4/ Has no Primary Key
 5/ Has ANSI NULLs set to OFF
 6/ Has no index at all
 7/ No candidate key (unique constraint on column(s))
 8/ Has disabled Index(es)
 9/ has leftover fake index(es)
10/ has a column collation different from the database
11/ Has a surprisingly low Fill-Factor
12/ Has disabled constraint(s)'
13/ Has untrusted constraint(s)'
14/ Has a disabled Foreign Key'
15/ Has untrusted FK'
16/ Has unrelated to any other table'
17/ Has a deprecated LOB datatype
18/ Has unintelligible column names'
19/ Has a foreign key that has no index'
20/ Has a GUID in a clustered Index
21/ Has non-compliant column names'
22/ Has a trigger that has'nt got NOCOUNT ON'
23/ Is not referenced by any procedure, view or function'
24/ Has  a disabled trigger' 
25/ Can't be indexed'
Revisions:
 - Author: Phil Factor
   Version: 1.1
   Modifications:
	-  added tests as suggested by comments to blog
   Date: 30 Mar 2016
 - Author: Phil Factor
   Version: 1.2
   Modifications:
	-  tidying, added five more smells
   Date: 10 July 2020
 - Author: Phil Factor
   Version: 1.3
   Modifications:
	-  re-engineered it for JSON output
   Date: 26 March 2021
 
 returns:   >
 single result of table name, and list of problems        
**/
declare  @TableSmells table (object_id INT, problem VARCHAR(200)) 
INSERT INTO @TableSmells (object_id, problem)
 SELECT object_id, 'wide (more than 15 columns)' AS Problem
          FROM sys.tables /* see whether the table has more than 15 columns */
          WHERE max_column_id_used > 15
        UNION ALL
        SELECT DISTINCT sys.tables.object_id, 'heap'
          FROM sys.indexes /* see whether the table is a heap */
            INNER JOIN sys.tables
              ON sys.tables.object_id = sys.indexes.object_id
          WHERE sys.indexes.type = 0
        UNION ALL
        SELECT s.object_id, 'Undocumented table'
          FROM sys.tables AS s /* it has no extended properties */
            LEFT OUTER JOIN sys.extended_properties AS ep
              ON s.object_id = ep.major_id AND minor_id = 0
          WHERE ep.value IS NULL
        UNION ALL
        SELECT sys.tables.object_id, 'No primary key'
          FROM sys.tables /* see whether the table has a primary key */
          WHERE ObjectProperty(object_id, 'TableHasPrimaryKey') = 0
        UNION ALL
        SELECT sys.tables.object_id, 'has ANSI NULLs set to OFF'
          FROM sys.tables /* see whether the table has ansii NULLs off*/
          WHERE ObjectPropertyEx(object_id, 'IsAnsiNullsOn') = 0
       UNION ALL
        SELECT sys.tables.object_id, 'No index at all'
          FROM sys.tables /* see whether the table has any index */
          WHERE ObjectProperty(object_id, 'TableHasIndex') = 0
        UNION ALL
        SELECT sys.tables.object_id, 'No candidate key'
          FROM sys.tables /* if no unique constraint then it isn't relational */
          WHERE ObjectProperty(object_id, 'TableHasUniqueCnst') = 0
            AND ObjectProperty(object_id, 'TableHasPrimaryKey') = 0
        UNION ALL
        SELECT DISTINCT object_id, 'disabled Index(es)'
          FROM sys.indexes /* don't leave these lying around */
          WHERE is_disabled = 1
        UNION ALL
        SELECT DISTINCT object_id, 'leftover fake index(es)'
          FROM sys.indexes /* don't leave these lying around */
          WHERE is_hypothetical = 1
        UNION ALL
        SELECT c.object_id,
          'has a column ''' + c.name + ''' that has a collation '''
          + collation_name + ''' different from the database'
          FROM sys.columns AS c
          WHERE Coalesce(collation_name, '') 
		  <> DatabasePropertyEx(Db_Id(), 'Collation')
        UNION ALL
        SELECT DISTINCT object_id, 'surprisingly low Fill-Factor'
          FROM sys.indexes /* a fill factor of less than 80 raises eyebrows */
          WHERE fill_factor <> 0
            AND fill_factor < 80
            AND is_disabled = 0
            AND is_hypothetical = 0
        UNION ALL
        SELECT DISTINCT parent_object_id, 'disabled constraint(s)'
          FROM sys.check_constraints /* hmm. i wonder why */
          WHERE is_disabled = 1
        UNION ALL
        SELECT DISTINCT parent_object_id, 'untrusted constraint(s)'
          FROM sys.check_constraints /* ETL gone bad? */
          WHERE is_not_trusted = 1
        UNION ALL
        SELECT DISTINCT parent_object_id, 'disabled FK'
          FROM sys.foreign_keys /* build script gone bad? */
          WHERE is_disabled = 1
        UNION ALL
        SELECT DISTINCT parent_object_id, 'untrusted FK'
          FROM sys.foreign_keys /* Why do you have untrusted FKs?       
      Constraint was enabled without checking existing rows;
      therefore, the constraint may not hold for all rows. */
          WHERE is_not_trusted = 1
        UNION ALL
        SELECT object_id, 'unrelated to any other table'
          FROM sys.tables /* found a simpler way! */
          WHERE ObjectPropertyEx(object_id, 'TableHasForeignKey') = 0
            AND ObjectPropertyEx(object_id, 'TableHasForeignRef') = 0
        UNION ALL
        SELECT object_id, 'deprecated LOB datatype'
          FROM sys.tables /* found a simpler way! */
          WHERE ObjectPropertyEx(object_id, 'TableHasTextImage') = 1 
       UNION ALL
        SELECT DISTINCT object_id, 'unintelligible column names'
          FROM sys.columns /* column names with no letters in them */
          WHERE name COLLATE Latin1_General_CI_AI NOT LIKE '%[A-Z]%' COLLATE Latin1_General_CI_AI
        UNION ALL
        SELECT keys.parent_object_id,
          'foreign key ' + keys.name + ' that has no supporting index'
          FROM sys.foreign_keys AS keys
            INNER JOIN sys.foreign_key_columns AS TheColumns
              ON keys.object_id = constraint_object_id
            LEFT OUTER JOIN sys.index_columns AS ic
              ON ic.object_id = TheColumns.parent_object_id
             AND ic.column_id = TheColumns.parent_column_id
             AND TheColumns.constraint_column_id = ic.key_ordinal
          WHERE ic.object_id IS NULL
        UNION ALL
        SELECT Ic.object_id, Col_Name(Ic.object_id, Ic.column_id)
          + ' is a GUID in a clustered index' /* GUID in a clustered IX */
          FROM sys.index_columns AS Ic
			INNER JOIN sys.tables AS tables
			ON tables.object_id = Ic.object_id
            INNER JOIN sys.columns AS c
              ON c.object_id = Ic.object_id AND c.column_id = Ic.column_id
            INNER JOIN sys.types AS t
              ON t.system_type_id = c.system_type_id
            INNER JOIN sys.indexes AS i
              ON i.object_id = Ic.object_id AND i.index_id = Ic.index_id
          WHERE t.name = 'uniqueidentifier'
            AND i.type_desc = 'CLUSTERED'
        UNION ALL
        SELECT DISTINCT object_id, 'non-compliant column names'
          FROM sys.columns /* column names that need delimiters*/
          WHERE name COLLATE Latin1_General_CI_AI LIKE '%[^_@$#A-Z0-9]%' COLLATE Latin1_General_CI_AI
        UNION ALL /* Triggers lacking `SET NOCOUNT ON`, which can cause unexpected results WHEN USING OUTPUT */
        SELECT ta.object_id,
          'This table''s trigger, ' + Object_Name(tr.object_id)
          + ', has''nt got NOCOUNT ON'
          FROM sys.tables AS ta /* see whether the table has any index */
            INNER JOIN sys.triggers AS tr
              ON tr.parent_id = ta.object_id
            INNER JOIN sys.sql_modules AS mo
              ON tr.object_id = mo.object_id
          WHERE definition NOT LIKE '%set nocount on%'
        UNION ALL /* table not referenced by any routine */
        SELECT sys.tables.object_id,
          'not referenced by procedure, view or function'
          FROM sys.tables /* found a simpler way! */
            LEFT OUTER JOIN sys.sql_expression_dependencies
              ON referenced_id = sys.tables.object_id
          WHERE referenced_id IS NULL
        UNION ALL
        SELECT DISTINCT parent_id, 'has a disabled trigger'
          FROM sys.triggers
          WHERE is_disabled = 1 AND parent_id > 0
        UNION ALL
        SELECT sys.tables.object_id, 'can''t be indexed'
          FROM sys.tables /* see whether the table has a primary key */
          WHERE ObjectProperty(object_id, 'IsIndexable') = 0
DECLARE @json NVARCHAR(MAX)
SELECT @json = (SELECT TableName, problem from
	(SELECT DISTINCT  Object_Schema_Name(Object_ID) + '.' + Object_Name(Object_ID) AS TableName,object_id, Count(*) AS smells
FROM @TableSmells GROUP BY Object_ID)f(TableName,Object_id, Smells)
INNER JOIN @TableSmells AS problems ON f.object_id=problems.object_id
ORDER BY smells desc
FOR JSON AUTO)
SELECT @Json
'@
	
	if (!([string]::IsNullOrEmpty($param1.uid)) -and ([string]::IsNullOrEmpty($param1.pwd)))
	{ $problems += 'No password is specified' }
	If (!(Test-Path -PathType Leaf  $MyOutputReport) -and ($problems.Count -eq 0))
	{
		if (!([string]::IsNullOrEmpty($param1.uid)))
		{
			$MyJSON = sqlcmd -S "$($param1.server)" -d "$($param1.database)" `
							 -Q `"$query`" -U $($param1.uid) -P $($param1.pwd) -o $MyOutputReport -u -y0
			$arguments = "$($param1.server) -d $($param1.database) -U $($param1.uid) -P $($param1.pwd) -o $MyOutputReport"
		}
		else
		{
			$MyJSON = sqlcmd -S "$($param1.server)" -d "$($param1.database)" -Q `"$query`" -E -o $MyOutputReport -u -y0
			$arguments = "$($param1.server) -d $($param1.database) -o $MyOutputReport"
		}
		if (!($?))
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Problems += "sqlcmd failed with code $LASTEXITCODE, $Myversions, with parameters $arguments"
		}
		$possibleError = Get-Content -Path $MyOutputReport -raw
		if ($PossibleError -like '*Sqlcmd: Error*')
		{
			$Problems += $possibleError;
			Remove-Item $MyOutputReport;
		}
		
	}
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'ExecuteTableSmellReport' += $problems;
	}
	else
	{
		$Param1.Locations.'ExecuteTableSmellReport' = $MyOutputReport;
	}
}

<# This places in a report a json report of the documentation of every table and its
columns. If you add or change tables, this can be subsequently used to update the 
AfterMigrate callback script
for the documentation */#>
$ExecuteTableDocumentationReport = {
	Param ($param1) # $ExecuteTableSmellReport - parameter is a hashtable 


	$problems = @()
	@('server', 'database', 'version', 'project') | foreach{
		if ($param1.$_ -eq $null)
		{ $Problems= "no value for '$($_)'" }
	}
	$escapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = "$($env:USERPROFILE)\$ReportLocation$(
		$EscapedProject)\$($param1.Version)\Reports"
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	$MyOutputReport = "$MyDatabasePath\TableDocumentation.JSON"
    
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCmd   $SQLCMDAlias -Scope local
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCMD is not set correctly yet' }
#The JSON Query must have 'SET NOCOUNT ON' and assign the result to 'NVARCHAR MAX' which you select from.

@'
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
DECLARE  @Json NVARCHAR(MAX)
DECLARE @TheSQExpression NVARCHAR(MAX)
DECLARE @TheErrorNumber INT
SELECT @TheErrorNumber=0
 BEGIN TRY
      EXECUTE sp_executesql  @stmt = N'Declare @null nvarchar(100)
	  SELECT @null=String_Agg(text,'','') FROM (VALUES (''testing''),(''testing''),(''one''),(''Two''),(''three''))f(Text)'
    END TRY
    BEGIN CATCH
       SELECT @TheErrorNumber=Error_Number() 
    END CATCH;
/*On Transact SQL language the Msg 195 Level 15 - 'Is not a recognized built-in function name'
 means that the function name is misspelled, not supported  or does not exist. */
IF @TheErrorNumber = 0 
SELECT @TheSQExpression=N'Select @TheJson=(SELECT Object_Schema_Name(TABLES.object_id) + ''.'' + TABLES.name AS TableObjectName,
     Lower(Replace(type_desc,''_'','' '')) AS [Type], --the type of table source
     Coalesce(Convert(NVARCHAR(3800), ep.value), '''') AS "Description",
      (SELECT Json_Query(''{''+String_Agg(''"''+String_Escape(TheColumns.name,N''json'')
            +''":''+''"''+Coalesce(String_Escape(Convert(NVARCHAR(3800),epcolumn.value),N''json''),'''')+''"'', '','')
            WITHIN GROUP ( ORDER BY TheColumns.column_id ASC )  +''}'') Columns
        FROM sys.columns AS TheColumns
         LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
          ON epcolumn.major_id = TABLES.object_id
         AND epcolumn.minor_id = TheColumns.column_id
		 AND epcolumn.class=1
         AND epcolumn.name = ''MS_Description'' --you may choose a different name
        WHERE TheColumns.object_id = TABLES.object_id)
     AS TheColumns
      FROM sys.objects tables
        LEFT OUTER JOIN sys.extended_properties ep
          ON ep.major_id = TABLES.object_id
         AND ep.minor_id = 0
         AND ep.name = ''MS_Description''
      WHERE type IN (''IF'',''FT'',''TF'',''U'',''V'')
FOR JSON auto)'
ELSE
SELECT @TheSQExpression=N'Select @TheJson=(SELECT Object_Schema_Name(TABLES.object_id) + ''.'' + TABLES.name AS TableObjectName,
     Lower(Replace(type_desc,''_'','' '')) AS [Type], --the type of table source
     Coalesce(Convert(NVARCHAR(3800), ep.value), '''') AS "Description",	
	
	(SELECT	Json_Query(''{''+Stuff((SELECT '', ''+''"''+String_Escape(TheColumns.name,N''json'')
            +''":''+''"''+Coalesce(String_Escape(Convert(NVARCHAR(3800),epcolumn.value),N''json''),'''')+''"''
		FROM sys.columns TheColumns
         LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
          ON epcolumn.major_id = Tables.object_id
         AND epcolumn.minor_id = TheColumns.column_id
		 AND epcolumn.class=1
         AND epcolumn.name = ''MS_Description'' --you may choose a different name
        WHERE TheColumns.object_id = Tables.object_id
		ORDER BY TheColumns.column_id
		 FOR XML PATH(''''), TYPE).value(''.'', ''nvarchar(max)''),1,2,'''')  +''}'' )) TheColumns
      FROM sys.objects tables
        LEFT OUTER JOIN sys.extended_properties ep
          ON ep.major_id = TABLES.object_id
         AND ep.minor_id = 0
         AND ep.name = ''MS_Description''
      WHERE type IN (''IF'',''FT'',''TF'',''U'',''V'')
FOR JSON AUTO)'

EXECUTE sp_EXECUTESQL @TheSQExpression,N'@TheJSON nvarchar(max) output',@TheJSON=@Json OUTPUT
SELECT @JSON
'@ > "$($env:Temp)\Temp.SQL"
	if (!([string]::IsNullOrEmpty($param1.uid)) -and ([string]::IsNullOrEmpty($param1.pwd)))
	{ $problems += 'No password is specified' }
	If (!(Test-Path -PathType Leaf  $MyOutputReport) -and ($problems.Count -eq 0)) # do the report once only
	{
        if ($Param1.uid -ne $null) #if we need to use credentials
        {
	         sqlcmd -S "$($param1.server)" -d "$($param1.database)" `
					         -i "$($env:Temp)\Temp.SQL" -U $($param1.uid) -P $($param1.pwd) `
					         -o $MyOutputReport -u -y0
        }
        else #we are using integrated security
        {
	         sqlcmd -S "$($param1.server)" -d "$($param1.database)" `
					         -i "$($env:Temp)\Temp.SQL" -E -o $MyOutputReport -u -y0
        }
        if (!($?)) #sqlcmd error
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Problems += "sqlcmd failed with code $LASTEXITCODE, $Myversions, with parameters $arguments"
		}
		$possibleError = Get-Content -Path $MyOutputReport -raw
		if ($PossibleError -like '*Sqlcmd: Error*')
		{
			$Problems += $possibleError;
			Remove-Item $MyOutputReport;
		}
 	     Remove-Item "$($env:Temp)\Temp.SQL";
    }
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'ExecuteTableDocumentationReport' += $problems;
	}
	else
	{
		$Param1.Locations.'ExecuteTableDocumentationReport' = $MyOutputReport;
	}
}



function Process-FlywayTasks
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[System.Collections.Hashtable]$DatabaseDetails,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[array]$Invocations
	)
	
	$Invocations | foreach{
		if ($DatabaseDetails.Problems.Count -eq 0)
		{#try to get the name of the task
			if ($_.Ast.Extent.Text -imatch '(?<=# ?\$)([\w]{5,80})')
			{ $TaskName = $matches[0] }
			else { $TaskName = 'unknown' }
			try # try executing the script block
			{ $returnedArray = $_.Invoke($DatabaseDetails) }
			catch #if it hit an exception
			{
				# handle the exception
				$where = $PSItem.InvocationInfo.PositionMessage
				$ErrorMessage = $_.Exception.Message
				$FailedItem = $_.Exception.ItemName
				$DatabaseDetails.Problems.exceptions += "$Taskname failed with $FailedItem : $ErrorMessage at `n $where."
			}
           	 "Executed $TaskName"
        }
		
	}

	#print out any errors and warnings. 
	if ($DatabaseDetails.Problems.Count -gt 0) #list out every problem and which task failed
	{
		$DatabaseDetails.Problems.GetEnumerator() |
		Foreach{ Write-warning "Problem! $($_.Key)---------"; $_.Value } |
		foreach { write-warning "`t$_" }
	}
	if ($DatabaseDetails.Warnings.Count -gt 0) #list out exery warning and which task failed
	{
		$DatabaseDetails.Warnings.GetEnumerator() |
		Foreach{ Write-warning "$($_.Key)---------"; $_.Value } |
		foreach { write-warning  "`t$_" }
	$DatabaseDetails.Warnings=@{}    
    }
	$DatabaseDetails.Locations.GetEnumerator() |
		Foreach{ Write-Output "For the $($_.Key), we saved the report in $($_.Value)" } 



<#    $DatabaseDetails.locations|gm -MemberType Property|foreach{
       "For the $($_.Name) we saved the result in $($databaseDetails.locations.($_.Name))"}#>
   }








'scriptblocks and cmdlet loaded. V29'
