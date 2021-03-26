﻿<#

$FetchOrSaveDetailsOfParameterSet
This checks over the scriptblock and  adds escaped values of server, database 
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

$GetCurrentVersion 
This contacts the database and determines its current version by interrogating
the flyway_schema_history data table in the database. It merely finds the highest
version number recorded as being successfully used. If it is an empty database,
or there is just no Flyway data, then it returns a version of 0.0.0.

$CheckCodeInDatabase 
This runs SQL code analysis on the scripted objects  within the database such as
procedure, functions and views within the database and saves the report and reports 
back any issues in the $DatabaseDetails hash table. It saves the reports in the
designated project directory, in a Reports folder, as a subfolder for the supplied
version (for example, in Pubs\1.1.5\Reports), so it needs $GetCurrentVersion to have
been run beforehand in the chain of tasks.

$CheckCodeInFiles
This runs SQL code analysis on the scripted objects  within the migration files and
saves the report and saves the reports in the designated project directory, in a
Reports folder, as a subfolder for the supplied version (for example, in Pubs\1.1.5\Reports).

$IsDatabaseIdenticalToSource: 
This uses SQL Compare to check that a version of a database is correct and hasn't been
changed. To do this, the $CreateScriptFoldersIfNecessary task must have been run
first. It compares the database to the associated source folder, for that version,
and returns, in the hash table, the comparison equal to true if it was the same,
or false if there has been drift, with a list of objects that have changed. If
the comparison returns $null, then it means there has been an error. To access
the right source folder for this database version, it needs $GetCurrentVersion
to have been run beforehand in the chain of tasks

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
#>

<# This scriptblock adds escaped values of server, database and project. 
it allows you to save and load the shared parameters for all these 
scriptblocks under a name you give it. you'd choose a different name for each database
within a project, but make them unique across projects 
If the parameters have the name defined but vital stuff missing, it fills 
in from the last remembered version. If it has the name and the vital stuff then it assumes
you want to save it. If no name then it ignores. 
#>

$FetchOrSaveDetailsOfParameterSet = {
	Param ($param1) # $FetchOrSaveDetailsOfParameterSet: the parameter is a hashtable
    $problems=@(); 
   	if ($Param1.name -ne $null -and $Param1.project -ne $null)
	{
		# define where we store our secret project details
		$StoredParameters = "$($env:USERPROFILE)\Documents\Deploy\$(($param1.Project).Split([IO.Path]::GetInvalidFileNameChars()) -join '_')";
		$ParametersFilename = 'AllParameters.json';
	}
	
	if ($Param1.name -ne $null -and $Param1.project -ne $null -and $Param1.Server -eq $null -and $Param1.Database -eq $null)
	{
		# we don't want to keep passwords unencrypted and we don't want any of the transitory
		# variables that provide state (warnings, error, version number and so on)
		$VariablesWeWant = @(
			'server', 'uid', 'port', 'project', 'database', 'projectFolder', 'projectDescription'
		);
		# If the directory doesn't exist then create it
		if (!(test-path -Path $StoredParameters -PathType Container))
		{ $null = New-Item -Path $StoredParameters -ItemType "directory" -Force }
		#if the file already exists then read it in.
		if (test-path "$StoredParameters\$($Param1.Name)-$ParametersFilename" -PathType leaf)
		{
			# so we read in all the details
			$TheActualParameters = Get-Content -Path "$StoredParameters\$($Param1.Name)-$ParametersFilename" -Raw | ConvertFrom-json
			$TheActualParameters.psobject.properties |
			Foreach { if ($_.Name -in $VariablesWeWant) { $param1[$_.Name] = $_.Value } }
			"fetched details from $StoredParameters\$($Param1.name)-$ParametersFilename"
		}
        else
        {
        $Problems+="Could not find project file $StoredParameters\$($Param1.Name)-$ParametersFilename "
        }
	}
	#if the user wants to save or resave they'll the name AND include both the the server and database
	elseif ($Param1.Name -ne $null -and $Param1.Server -ne $null -and $Param1.Database -ne $null)
	{
		$RememberedHashTable = @{ }
		$VariablesWeWant | foreach{ $RememberedHashTable.$_ = $param1.$_ }
		$RememberedHashTable | ConvertTo-json |
		out-file -FilePath "$StoredParameters\$($Param1.name)-$ParametersFilename" -Force
		"Saved details to $StoredParameters\$($Param1.name)-$ParametersFilename"
	}
    # This section is to check for values that really should be there and if
    # necessary, insert them.
	# some values, especially server names, have to be escaped when used in file paths.
	if ($Param1.'Escapedserver' -eq $null)
	{
		"Escaping"
		$EscapedValues = @()
		$EscapedValues += $Param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $_.GetEnumerator() } | foreach{ $param1[$_.Name] = $_.Value }
	}
    if ($Param1.'Checked' -eq $null) {$Param1.'Checked' = $false;} 
      # has it been checked against a source directory?
	$Param1.'Problems' = @{ };
	$Param1.'Warnings' = @{ };
@('server', 'database', 'projectFolder','project')|
    foreach{ if ($param1.$_ -eq $null) { $Problems+= "no value for '$($_)'" } }
if ($problems.Count -gt 0)
    {$Param1.Problems.'FetchOrSaveDetailsOfParameterSet' += $problems;}
}

<# now we format the Flyway parameters #>
#>

$FormatTheBasicFlywayParameters = {
	Param ($param1) # $FormatTheBasicFlywayParameters the parameter is hashtable
	@('server', 'database', 'projectFolder') |
	foreach{ if ($param1.$_ -eq $null) { "no value for '$($_)'" } }
	
	$MaybePort = "$(if ([string]::IsNullOrEmpty($param1.port)) { '' }
		else { ":$($param1.port)" })"
	if (!([string]::IsNullOrEmpty($param1.uid)))
	{
		$FlyWayArgs =
		@("-url=jdbc:sqlserver://$($param1.Server)$maybePort;databaseName=$($param1.Database)",
			"-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
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
}



<# This scriptblock looks to see if we have the passwords stored for this userid and daytabase
if not we ask for it and store it encrypted in the user area
 #>

$FetchAnyRequiredPasswords = {
	Param ($param1) # $FetchAnyRequiredPasswords the parameter is hashtable
    $problems=@()
    @('server') |
	foreach{ if ($param1.$_ -eq $null) { $problem="no value for '$($_)'" } }
	# some values, especially server names, have to be escaped when used in file paths.
	if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	# now we get the password if necessary
	if ($param1.uid -ne '') #then it is using SQL Server Credentials
	{
		# we see if we've got these stored already
		$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($param1.uid)-$($param1.Escapedserver).xml"
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
$OurDetails=@{
  'server'='MyServer'; 
  'Database'='MyDatabase'; 
  'version'='1.1.15';
  'project'='MyProjectName';
  'uid'='MyUID'; #if necessary!
  'pwd'='MyPassword'#if necessary!
  'warnings'=@{};'problems'=@{};}
$CheckCodeInDatabase.Invoke($OurDetails)
$OurDetails.warnings.CheckCodeInDatabase
 #>
$CheckCodeInDatabase = {
	Param ($param1) # $CheckCodeInDatabase - the parameter is a hashtable
	#you must set this value correctly before starting.
	Set-Alias CodeGuard "${env:ProgramFiles(x86)}\SQLCodeGuard\SqlCodeGuard30.Cmd.exe" -Scope local
	$Problems = @(); #our local problem counter
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }
	if ($param1.Escapedserver -eq $null) #double-check that escapedValues are in place
	{
		#we need this to wotk out the location for the report
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{
				"Escaped$($_.Name)" = (
					$_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')
			}
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	#check that all the values we need are in the hashtable
	@('server', 'Database', 'version', 'EscapedProject') |
	foreach{ if ($param1.$_ -eq $null) { $Problems += "no value for '$($_)'" } }
	#now we create the parameters for CodeGuard.
	$MyDatabasePath = "$($env:USERPROFILE)\Documents\GitHub\$(
		$param1.EscapedProject)\$($param1.Version)\Reports"
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
			$Args += $Arguments.GetEnumerator() |
			foreach{ "$($_.Name)=$($_.Value)" }
			$problems += "CodeGuard responded '$result' with error code $LASTEXITCODE when used with parameters $Args."
		}
		$Problems += $result | where { $_ -like '*error*' }
	}
	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInDatabase! ";
		$Param1.Problems.'CheckCodeInDatabase' += $problems;
	}
	
	else #now we read in the XML report and turn it into an ASCII report
	{
		
		[xml]$XmlDocument = Get-Content -Path "$MyDatabasePath\codeAnalysis.xml"
		$warnings = @();
		$warnings += $XmlDocument.root.GetEnumerator() | foreach{
			$name = $_.name.ToString();
			$_.issue
		} |
		select-object  @{ Name = "Object"; Expression = { $name } },
					  code, line, text
		$Param1.Warnings.'CheckCodeInDatabase' += $warnings
	}
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
	Param ($param1) # $CheckCodeInMigrationFiles - the parameter is a hashtable
	#you must set this value correctly before starting.
	Set-Alias CodeGuard "${env:ProgramFiles(x86)}\SQLCodeGuard\SqlCodeGuard30.Cmd.exe" -Scope local
	$Problems = @(); #our local problem counter
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }
	if ($param1.EscapedProject -eq $null) #double-check that escapedValues are in place
	{
		#we need this to wotk out the location for the report
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{
				"Escaped$($_.Name)" = (
					$_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')
			}
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	#check that all the values we need are in the hashtable
	@('EscapedProject','ProjectFolder') |
	foreach{ if ($param1.$_ -eq $null) { $Problems += "no value for '$($_)'" } }
    dir "$($param1.projectFolder)/scripts/V*.sql" | foreach{
	    $Thepath = $_.FullName;
	    $TheFile = $_.Name
	    $Theversion = ($_.Name -replace 'V(?<Version>[.\d]+).+', '${Version}')
	    #now we create the parameters for CodeGuard.
	    $MyDatabasePath = "$($env:USERPROFILE)\Documents\GitHub\$(
		    $param1.EscapedProject)\$TheVersion\Reports"
	    $Arguments = @{
		    source = $ThePath
		    outfile = "$MyDatabasePath\FilecodeAnalysis.xml" <#
            The file name in which to store the analysis xml report#>
		    #exclude='BP007;DEP004;ST001' 
		    #A semicolon separated list of rule codes to exclude
		    include = 'all' #A semicolon separated list of rule codes to include
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
				    Test-Path -PathType leaf  "$MyDatabasePath\FilecodeAnalysis.xml")))
	    {
		    $result = codeguard @Arguments; #execute the command-line Codeguard.
		    if ($? -or $LASTEXITCODE -eq 1)
		    {
			    "Written file Code analysis for $TheFile for $($param1.Project) project) to $MyDatabasePath\FilecodeAnalysis.xml"
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
		    $Problems += $result | where { $_ -like '*error*' }
	    }
    }
	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInMigrationFiles! ";
		$Param1.Problems.'CheckCodeInMigrationFiles' += $problems;
	}
}


<#This scriptblock gets the current version of a flyway_schema_history data from the 
table in the database. if there is no Flyway Data, then it returns a version of 0.0.0
 #>
$GetCurrentVersion = {
	Param ($param1) # $GetCurrentVersion parameter is a hashtable 
	@('server', 'database') | foreach{ if ($param1.$_ -eq $null) { write-error "no value for '$($_)'" } }
	if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCmd   "$($env:ProgramFiles)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe" -Scope local
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
	Param ($param1) # $IsDatabaseIdenticalToSource the parameter is a hashtable
	$problems = @();
	$warnings = @();
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -eq $null) { $problems += "no value for '$($_)'" } }
	if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	if ($param1.Version -eq '0.0.0') { $identical = $null; $warnings += "Cannot compare an empty database" }
	$GoodVersion = try { $null = [Version]$param1.Version; $true }
	catch { $false }
	if (-not ($goodVersion))
	{ $problems += "Bad version number '$($param1.Version)'" }
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 13\sqlcompare.exe" -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	if ($problems.Count -eq 0)
	{
		#the database scripts path would be up to you to define, of course
		$MyDatabasePath = "$($env:USERPROFILE)\Documents\GitHub\$($param1.EscapedProject)\$($param1.Version)\Source"
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
	if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 13\sqlcompare.exe" -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
	$MyDatabasePath = "$($env:USERPROFILE)\Documents\GitHub\$($param1.EscapedProject)\$($param1.Version)\Source"
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
	Param ($param1) # $CreateBuildScriptIfNecessary the parameter is hashtable 
	$problems = @();
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -eq $null) { $Problems += "no value for '$($_)'" } }
	if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 13\sqlcompare.exe" -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
	$MyDatabasePath = "$($env:USERPROFILE)\Documents\GitHub\$($param1.EscapedProject)\$($param1.Version)\Scripts"
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
'scriptblocks loaded'
