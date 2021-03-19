
<# This scriptblock looks to see if we have the passwords stored for this userid and daytabase
if not we ask for it and store it encrypted in the user area
 #>

$FetchAnyRequiredPasswords = {
	Param ($param1) # the parameter is hashtable that contains all the useful values
	@('server') |
	foreach{ if ($param1.$_ -eq $null) { "no value for '$($_)'" } }
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
}

<#This scriptblock checks the code in the database for any issues, using SQL Code Guard
to do all the work. This runs SQL Codeguard and saves the report. It also reports back
in the $DatabaseDetails Hashtable.#>

$CheckCodeInDatabase = {
	Param ($param1) # the parameter is hashtable that contains all the useful values
	#you must set this value correctly before starting.
	Set-Alias CodeGuard "${env:ProgramFiles(x86)}\SQLCodeGuard\SqlCodeGuard30.Cmd.exe" -Scope local
	$Problems = @();
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	    { $Problems += 'The alias for Codeguard is not set correctly yet' }
    if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
    {
	    $EscapedValues = $param1.GetEnumerator() | 
           where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
		     @{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
	    }
    $EscapedValues | foreach{ $param1 += $_ }
    }
    #check that all the values we need are in the hashtable
	@('server', 'Database', 'version', 'EscapedProject') |
	foreach{ if ($param1.$_ -eq $null) { $Problems += "no value for '$($_)'" } }
	#now we create the parameters for CodeGuard.
	$MyDatabasePath = "$($env:USERPROFILE)\Documents\GitHub\$($param1.EscapedProject)\$($param1.Version)\Reports"
	$Arguments = @{
		server = $($param1.server) #The server name to connect
		Database = $($param1.database) #The database name to analyze
		outfile = "$MyDatabasePath\codeAnalysis.xml" #The file name in which to store the analysis xml report
		#exclude='BP007;DEP004;ST001' #A semicolon separated list of rule codes to exclude
		include = 'all' #A semicolon separated list of rule codes to include
	}
	
	if (!([string]::IsNullOrEmpty($param1.uid))) #add the arguments for credentials where necessary
	{
		$Arguments += @{
			User = $($param1.uid)
			Password = $($param1.pwd)
		}
	}
	if (-not (Test-Path -PathType Container $MyDatabasePath)) # we need to make sure tha path is there
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	#we only do the analysis if it hasn't already been done for this version, and we've hit no problems
	if (($problems.Count -eq 0) -and (-not (Test-Path -PathType leaf  "$MyDatabasePath\codeAnalysis.xml")))
	{
		$result = codeguard @Arguments; #execute the command-line Codeguard.
		if ($?) { "Written Code analysis for $($param1.Project) $($param1.Version) to $MyDatabasePath\codeAnalysis.xml" }
		else
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $args | foreach{ $_ }
			$problems += "CodeGuard responded with error code $LASTEXITCODE when used with paramaters $Arguments."
		}
		$Problems += $result | where { $_ -like '*error*' }
	}
	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInDatabase! ";
		$param1.Problems += @{ 'Name' = 'CheckCodeInDatabase'; Issues = $problems }
	}
	
	else
	{
		
		[xml]$XmlDocument = Get-Content -Path "$MyDatabasePath\codeAnalysis.xml"
        $warnings=@();
		$warnings += $XmlDocument.root.GetEnumerator() | foreach{
			$name = $_.name.ToString();
			$_.issue
		} |
		select-object  @{ Name = "Object"; Expression = { $name } },
					  code, line, text
		$param1.Warnings += @{ 'Name' = 'CheckCodeInDatabase'; Issues = $warnings }
	}
}



<#This scriptblock gets the current version of a flyway_schema_history data from the 
table in the database. if there is no Flyway Data, then it returns a version of 0.0.0
 #>
$GetCurrentVersion = {
	Param ($param1) # the parameter is hashtable that contains all the useful values
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
	$problems = @();
	Set-Alias SQLCmd   "$($env:ProgramFiles)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe" -Scope local
	$Problems = @();
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }	$Version = 'unknown'
	$query = 'SELECT [version] FROM dbo.flyway_schema_history where success=1'
	$login = if ($param1.uid -ne $null)

	{
		$Myversions = sqlcmd -h -1 -S "$($param1.server)" -d "$($param1.database)" `
							 -Q `"$query`" -U $($param1.uid) -P $($param1.pwd) -u -W
        $arguments="$($param1.server) -d $($param1.database) -U $($param1.uid) -P $($param1.pwd)"
	}
	else
	{ $Myversions = sqlcmd -h -1 -S "$($param1.server)" -d "$($param1.database)" -Q `"$query`" -E -u -W
        $arguments="$($param1.server) -d $($param1.database)"
     }
	if (!($?) -or ($Myversions -eq $null))
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Problems+= "sqlcmd failed with code $LASTEXITCODE, $Myversions, with parameters $arguments"
	    }
	elseif (($Myversions -join '-') -like '*Invalid object name*')
         { $Version = '0.0.0' }
	else
	{
		$Version = ($Myversions | where { $_ -like '*.*.*' } |
			foreach { [version]$_ } |
			Measure-Object -Maximum).Maximum.ToString()
	}
	if ($problems.Count -gt 0) {Write-error "$problems happened!";
        $param1.Problems += @{'Name'='GetCurrentVersion';'Issues'=$problems} }
	$param1.Version = $version
}

<# This uses SQL Compare to check that a version of a database is correct and hasn't been changed.
It returns comparison equal to true if it was the same or false if there has been drift, 
with a list of objects that have changed. if the comparison returns $null, then it means there 
has been an error #>


$IsDatabaseIdenticalToSource = {
	Param ($param1) # the parameter is hashtable that contains all the useful values
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
	if ($param1.Version -eq '0.0.0') { $identical=$null; $warnings += "Cannot compare an empty database" }
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
		else { $identical = $null;
                $Warnings="source folder '$MyDatabasePath' did not exist so can't check" 
            }
 		
	}
   $param1.Checked = $identical
   if ($problems.Count -gt 0)
         { $param1.Problems += @{'Name'='IsDatabaseIdenticalToSource';'Issues'=$problems} }
   if ($warnings.Count -gt 0)
        {$param1.Warnings += @{ 'Name' = 'IsDatabaseIdenticalToSource'; 'Issues' = $warnings} }
}


<#this routine checks to see if a script folder already exists for this version
of the database and, if not, it will create one and fill it with subdirectories
for each type of object. A tables folder will, for example, have a file for every table
each containing a  build script to create that object.
When this exists, it allows SQL Compare to do comparisons and check that a version has not
drifted.#>

$CreateScriptFoldersIfNecessary = {
	Param ($param1) # the parameter is hashtable that contains all the useful values
    $Problem=@();	#We check that it contains the keys for the values that we need 
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
	if ($problems.Count -eq 0 -and(!(Test-Path -PathType Container $MyDatabasePath)))#if it doesn't already erxist
	{
		Sqlcompare @Args #write an object-level  script folder that represents the vesion of the database
		if ($?) { "Written script folder for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
		else
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $args | foreach{ $_ }
			$problems+="SQL Compare responded with error code $LASTEXITCODE when used with paramaters $Arguments."
		}
    if ($problems.count -gt 0) 
        { $param1.Problems += @{'Name'='CreateScriptFoldersIfNecessary';Issues=$problems}}
	}
	else { "This version is already scripted in $MyDatabasePath " }
}

<# a script block that produces a build script from a database, using SQL Compare. #>

$CreateBuildScriptIfNecessary = {
	Param ($param1) # the parameter is hashtable that contains all the useful values
    $problems=@();
	@('version', 'server', 'database', 'project') | foreach{ if ($param1.$_ -eq $null) { $Problems+="no value for '$($_)'" } }
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
			$Problems+= "SQLCompare Went badly. (code $LASTEXITCODE) with paramaters $Arguments."
		}
    if ($problems.count -gt 0) 
        { $param1.Problems += @{'Name'='CreateBuildScriptIfNecessary';Issues=$problems}}
	}
	else { "This version already has a build script at $MyDatabasePath " }

}
'scriptblocks loaded'

