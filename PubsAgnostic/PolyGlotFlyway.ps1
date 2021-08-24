Set-Alias Flyway  $env:flyway -Scope local
<#
	.SYNOPSIS
		Creates Flyway Parameter sets from a list of placeholders and parameters
	
	.DESCRIPTION
		A way of generating a whole lot of parameter sets that can be applied to Flyway. 
Each object of the Flyway Array creates a set of Flyway parameters. 
The routine automatically stores and inserts passwords, and runs various checks as well 
as creating the Flyway parameters.
	
	.PARAMETER ProjectFolder
		The path to the project folder containing the migrtation scripts
	
	.PARAMETER ProjectDescription
		A description of the project
	
	.PARAMETER ProjectName
		The name you give to the project
	
	.PARAMETER FlywayArray
		The collection of data objects that describe each database

	.PARAMETER WhichToDo
        A wildcard to specify which of the whole collection you want to process

	.PARAMETER $ConfigFile
        Is this to create a config file rather than a list of parameters?. 
	
	.EXAMPLE
				PS C:\> Create-FlyWayParametersets -ProjectFolder $value1 -ProjectDescription $value2
	
	.NOTES
		Additional information about the function.
#>
function Create-FlyWayParametersets
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$ProjectFolder,
		[Parameter(Mandatory = $true)]
		$ProjectDescription,
		[Parameter(Mandatory = $true)]
		$ProjectName,
		[Parameter(Mandatory = $true)]
		$FlywayArray,
		[Parameter(Mandatory = $False)]
		$WhichToDo = '*',
		#meaning do all the database. You can do just one or a few

		[Parameter(Mandatory = $False)]
		$ConfigFile = $False #Change to $true if you are writing config files 
	)
	if ($ConfigFile) { $Dlmtr = ''; $Prefix = 'Flyway.' }
	else { $Dlmtr = '"'; $Prefix = '-' }
	
	$TheDatabases = $FlywayArray | Where { $_.RDBMS -like $WhichToDo } | foreach {
		if (!([string]::IsNullOrEmpty($_.UserID))) #then it is using integrated Credentials
		{
			# we see if we've got these stored already
			#if you change your password, you just delete the file
			$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($_.UserID)-$($_.Server)-$($_.RDBMS).xml"
			# test to see if we know about the password in a secure string stored in the user area
			if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
			{
				#has already got this set for this login so fetch it
				$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
			}
			else #then we have to ask the user for it (once only)
			{
				# hasn't got this set for this login
				$aborted = $false #in case the user doesn't want to enter the password
				$SqlCredentials = get-credential -Credential $_.UserID
				# Save in the user area 
				if ($SqlCredentials -ne $null) #in case the user aborted
				{
					$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
				}
				else { $aborted = $True }
			}
			#so we can now provide the password
			$_.Password = "$($SqlCredentials.GetNetworkCredential().password)";
			$_.UserID = $($SqlCredentials.UserName)
		}
		$URL = switch ($_.driver) # we need to get the right format of URL
		{
			'sqlserver'  { 'jdbc:<driver>://<host>:<port>;databaseName=<database>' } #sqlServer
			'mariadb'    { 'jdbc:<driver>://<host>:<port>/<database>' } # mariadb
			'postgresql' { 'jdbc:<driver>://<host>:<port>/<database>' } #postgresql 
			'sqlite'     { 'jdbc:sqlite:<database>' } #the database is a file address
			default { 'unrecognised driver' }
		}
		@(#now we substitute the real values for the placeholders
			@{ '<driver>' = $_.Driver }, @{ '<host>' = $_.Server },
			@{
				':<port>' = "$(if ($_.Port -eq '') { '' }
					else { ':' + $_.port })"
			},
			@{
				'<database>' = "$($_.Database)$(if ($_.driver -ne 'sqlite' -and ($_.UserID -eq '' -or
							$_.Password -eq '')) { ';integratedSecurity=true' }
					else { '' })" # integratedSecurity not for SQLITE! 
			}
		) | foreach{
			# replace each macro/placeholder with its value
			$URL = $URL.Replace($_.Keys[0], $_.Values[0])
		}
		# Now we need to deal with the rest of the values 
		$FlArgs = @();
		$FlArgs = @("$($Prefix)url=$URL",
			"$($Prefix)user=$($_.UserID)",
			"$($Prefix)password=$($_.Password)"
		) # now add the global project-variables for all databases
		$FlArgs += @("$($Prefix)locations=filesystem:$ProjectFolder\Scripts",
			"$($Prefix)schemas=$($_.schemas)");
		$FlArgs += <# the project variables that we reference with placeholders #>
		@("$($Prefix)placeholders.projectDescription=$Dlmtr$ProjectDescription$Dlmtr",
			"$($Prefix)placeholders.projectName=$Dlmtr$ProjectName$Dlmtr") <# the project variables #>
		$placeholders = $_.PlaceHolders
		$PlaceHolders.Keys | foreach{
			$FlArgs += "$($Prefix)placeholders.$_=$Dlmtr$($placeholders.$_)$Dlmtr"
		}
		@{
			'url' = $URL;
			'args' = $FLArgs;
		}
	}
	$TheDatabases
}



$FlywayArray = @(
	@{
		'RDBMS' = 'PostgreSQL';
		'driver' = 'postgresql';
		'Server' = 'MyServer'; #the name or instance of SQL Server
		'Database' = 'pubspolyglot'; #The name of the development database that you are using
		'Password' = ''; #your password 
		'UserID' = 'MyUserID'; # your userid 
		'port' = '5432'
		'Schemas' = 'dbo,people'
		'PlaceHolders' = @{
			'currentDateTime' = 'CURRENT_DATE';
			'schemaPrefix' = 'dbo.';
			'CLOB' = 'TEXT';
			'BLOB' = 'BYTEA';
			'autoIncrement' = 'INT NOT NULL GENERATED ALWAYS AS IDENTITY primary key';
			'DateDatatype' = 'DATE';
			'hexValueStart' = "decode('";
			'hexValueEnd' = "','hex')";
			'arg' = '';
			'viewStart' = ''
			'viewFinish' = '';
			'procStart' = '';
			'emptyProcArgs' = '()';
			'procBegin' = 'Language SQL as $$';
			'procEnd' = '$$;';
			'procFinish' = '';
			
		}
	},
	@{
		'RDBMS' = 'SQLite';
		'driver' = 'sqlite';
		'Server' = ''; #the name or instance of SQL Server
		'Database' = 'C:\Users\andre\sqlite\PubsPolyglot.sqlite3'; #The name of the development database that you are using
		'Password' = ''; #your password 
		'UserID' = ''; # your userid 
		'port' = ''
		'Schemas' = ''
		'PlaceHolders' = @{
			'currentDateTime' = "DATE('now')";
			'schemaPrefix' = '';
			'CLOB' = 'clob';
			'BLOB' = 'blob';
			'autoIncrement' = 'INTEGER PRIMARY KEY autoincrement';
			'DateDatatype' = 'varchar(50)';
			'hexValueStart' = "x'";
			'hexValueEnd' = "'"
			'arg' = '';
			'viewStart' = ''
			'viewFinish' = '';
			'procStart' = '/*'; #sqlite can't do procs
			'emptyProcArgs' = '';
			'procBegin' = '';
			'procEnd' = '';
			'procFinish' = '*/'; #sqlite can't do procs
			
		}
	},
	@{
		'RDBMS' = 'SQLServer';
		'driver' = 'sqlserver';
		'Server' = 'MyServer'; #the name or instance of SQL Server
		'Database' = 'pubsPolyglot'; #The name of the development database that you are using
		'Password' = ''; #your password 
		'UserID' = 'MyUserID'; # your userid
		'port' = '';
		'Schemas' = 'dbo,people'
		'PlaceHolders' = @{
			'currentDateTime' = 'GetDate()';
			'schemaPrefix' = 'dbo.';
			'CLOB' = 'NVARCHAR(MAX)';
			'BLOB' = 'varbinary(MAX)';
			'dateDatatype' = 'DateTime2';
			'autoIncrement' = 'INT NOT NULL IDENTITY primary key';
			'hexValueStart' = "0x";
			'hexValueEnd' = ""
			'arg' = '@';
			'viewStart' = 'GO';
			'viewFinish' = 'GO';
			'procStart' = '--';
			'emptyProcArgs' = '';
			'procBegin' = 'as';
			'procEnd' = '--';
			'procFinish' = 'GO';
		}
	},
	@{
		'RDBMS' = 'MariaDB';
		'driver' = 'mariadb';
		'Server' = 'MyServer'; #the name or instance of SQL Server
		'Database' = 'pubsPolyglot'; #The name of the development database that you are using
		'Password' = ''; #your password 
		'UserID' = 'MyUserID'; # your userid 
		'port' = '3307'
		'Schemas' = 'pubsPolyglot'
		'PlaceHolders' = @{
			'currentDateTime' = 'CURDATE()';
			'schemaPrefix' = '';
			'CLOB' = 'longtext';
			'BLOB' = 'longblob';
			'dateDatatype' = 'DateTime';
			'autoIncrement' = 'int NOT NULL auto_increment primary key';
			'hexValueStart' = "decode('";
			'hexValueEnd' = "','hex')";
			'arg' = '';
			'viewStart' = '';
			'viewFinish' = '';
			'procStart' = 'DELIMITER //';
			'emptyProcArgs' = '()';
			'procBegin' = 'Begin';
			'procEnd' = 'end;';
			'procFinish' = '//     DELIMITER ;';
			
		}
	})



<# an example of using the cmdlet to do a complete rebuild to all 
databases specified in our $FlywayArray array #>

Create-FlyWayParametersets `
   -ProjectFolder 'PathToProject\PubsAndFlyway\PubsAgnostic' `
   -ProjectDescription 'Experiment to use a single migration folder for several RDBMSs' `
   -ProjectName 'PubsAgnostic' -FlywayArray $FlywayArray | foreach {
	"... processing $($_.url)"
	$Params = $_.args
	Flyway @Params clean
	$Result = Flyway @Params -outputType=json migrate | convertFrom-JSON
	if ($Result.error -ne $null)
	{ write-warning $Result.error.message }
	else # we report any migration
	{
		$Before = $result.initialSchemaVersion;
		$After = $result.targetSchemaVersion;
		if ([string]::IsNullOrEmpty($before)) { $Before = 'empty' }
		if ([string]::IsNullOrEmpty($After)) { $After = $Before }
		if ($Before -ne $after)
		{ "$($result.database) $($Result.operation)d $($Result.migrationsExecuted) version(s) from $before to $After" }
		else
		{ 'No migration was made' }
	}
}

<# an example of using the cmdlet to write a config file in a subdirectory of 
the user home directory for each databases specified in our $FlywayArray array #>

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
Create-FlyWayParametersets `
	   -ProjectFolder 'S:\work\Github\PubsAndFlyway\PubsAgnostic' `
	   -ProjectDescription 'Experiment to use a single migration folder for several RDBMSs' `
	   -ProjectName 'PubsAgnostic' -FlywayArray $FlywayArray -ConfigFile $true | Foreach{
	$TheName = ($_.url -split ':')[1]
    $outputPath="$env:USERPROFILE\Documents\Databases\Pubs$TheName" 
    if (!(test-path -Path $outputPath -PathType Container))
        {New-Item -ItemType Directory -Force -Path $outputPath|out-null}
	$_.args > "$outputPath\flyway.conf"
}


