function Join-PipelineStrings <# simple function to turn a stream of strings into 
one long string #>
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$String,
        [Parameter(Position = 1)][string]$Delimiter = "`n"
    )
    BEGIN {$items = @() }
    PROCESS { $items += $String }
    END { return ($items -join $Delimiter) }
}

<#

Machine-readable output
Add -outputType=json to the argument list to print JSON instead of human-readable
output. Errors are included in the JSON payload instead of being sent to stderr.

Writing to a file
Add -outputFile=/my/output.txt

Commands
--------
migrate  : Migrates the database
clean    : Drops all objects in the configured schemas
info     : Prints the information about applied, current and pending migrations
validate : Validates the applied migrations against the ones on the classpath
undo     : [teams] Undoes the most recently applied versioned migration
baseline : Baselines an existing database at the baselineVersion
repair   : Repairs the schema history table

Options (Format: -key=value)
-------
driver                       : Fully qualified classname of the JDBC driver
url                          : Jdbc url to use to connect to the database
user                         : User to use to connect to the database
password                     : Password to use to connect to the database
connectRetries               : Maximum number of retries when attempting to connect to the database
initSql                      : SQL statements to run to initialize a new database connection
schemas                      : Comma-separated list of the schemas managed by Flyway
table                        : Name of Flyway's schema history table
locations                    : Classpath locations to scan recursively for migrations
resolvers                    : Comma-separated list of custom MigrationResolvers
skipDefaultResolvers         : Skips default resolvers (jdbc, sql and Spring-jdbc)
sqlMigrationPrefix           : File name prefix for versioned SQL migrations
undoSqlMigrationPrefix       : [teams] File name prefix for undo SQL migrations
repeatableSqlMigrationPrefix : File name prefix for repeatable SQL migrations
sqlMigrationSeparator        : File name separator for SQL migrations
sqlMigrationSuffixes         : Comma-separated list of file name suffixes for SQL migrations
stream                       : [teams] Stream SQL migrations when executing them
batch                        : [teams] Batch SQL statements when executing them
mixed                        : Allow mixing transactional and non-transactional statements
encoding                     : Encoding of SQL migrations
placeholderReplacement       : Whether placeholders should be replaced
placeholders                 : Placeholders to replace in sql migrations
placeholderPrefix            : Prefix of every placeholder
placeholderSuffix            : Suffix of every placeholder
lockRetryCount               : The maximum number of retries when trying to obtain a lock
jdbcProperties               : Properties to pass to the JDBC driver object
installedBy                  : Username that will be recorded in the schema history table
target                       : Target version up to which Flyway should use migrations
cherryPick                   : [teams] Comma separated list of migrations that Flyway should consider when migrating
skipExecutingMigrations      : [teams] Whether Flyway should skip actually executing the contents of the migrations
outOfOrder                   : Allows migrations to be run "out of order"
callbacks                    : Comma-separated list of FlywayCallback classes, or locations to scan for FlywayCallback classes
skipDefaultCallbacks         : Skips default callbacks (sql)
validateOnMigrate            : Validate when running migrate
validateMigrationNaming      : Validate file names of SQL migrations (including callbacks)
ignoreMissingMigrations      : Allow missing migrations when validating
ignoreIgnoredMigrations      : Allow ignored migrations when validating
ignorePendingMigrations      : Allow pending migrations when validating
ignoreFutureMigrations       : Allow future migrations when validating
cleanOnValidationError       : Automatically clean on a validation error
cleanDisabled                : Whether to disable clean
baselineVersion              : Version to tag schema with when executing baseline
baselineDescription          : Description to tag schema with when executing baseline
baselineOnMigrate            : Baseline on migrate against uninitialized non-empty schema
configFiles                  : Comma-separated list of config files to use
configFileEncoding           : Encoding to use when loading the config files
jarDirs                      : Comma-separated list of dirs for Jdbc drivers & Java migrations
createSchemas                : Whether Flyway should attempt to create the schemas specified in the schemas property
dryRunOutput                 : [teams] File where to output the SQL statements of a migration dry run
errorOverrides               : [teams] Rules to override specific SQL states and errors codes
oracle.sqlplus               : [teams] Enable Oracle SQL*Plus command support
licenseKey                   : [teams] Your Flyway license key
color                        : Whether to colorize output. Values: always, never, or auto (default)
outputFile                   : Send output to the specified file alongside the console
outputType                   : Serialise the output in the given format, Values: json

Flags
-----
-X          : Print debug output
-q          : Suppress all output, except for errors and warnings
-n          : Suppress prompting for a user and password
-v          : Print the Flyway version and exit
-?          : Print this usage info and exit
-community  : Run the Flyway Community Edition (default)
-teams      : Run the Flyway Teams Edition

#>

# flyway -? #Means get help! 
#create an alias for the commandline Flyway, IMPORTANT set to your path 
Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-7.3.1\flyway.cmd' -Scope local
# and here are our project details. The project folder
$configuration = @{
	# to describe the database for monitoring systems and reporting
	'ProjectFolder' ='MyPathTo\Github\PubsAndFlyway\PubsFlywaySecondMigration'; # where the migration scripts are stored
    'GlobalSettings' =@{
       'outputType'='json';
       'outputFile'='<projectFolder>\Reports\<server><database>.json';#the macros in angle brackets get filled in 
       # the outputfile you can specify the current database with the macro <database>, likewise <server> and <date> 
       'placeholders.ProjectName' = 'Publications'; # this gets used for reporting
	   'placeholders.ProjectDescription' = 'A sample project to show how to build a database and fill it with data';
	   'placeholders.Datasource' = 'Pubs'}
    'GlobalActions' =@('clean','migrate', 'info');#a list of flyway actions you wish to perform, in order
    <# emigrate, clean, info, validate, undo, baseline or repair #>
    'GlobalFlags'=@('community'); # 'X','q','n','v','?','community','teams'
	'Databases' = @(
		@{
		    Server = 'MyFirstServer' # the name of the server
		    Database = 'PubsEight'; # The name of the database we are currently migrating
		    Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '1433';
			Settings=@{target = '1.1.6'};
            Flags=@('community'); # 'X','q','n','v','?','community','teams'
		},
		@{
		    Server = 'MySecondServer' # the name of the server
		    Database = 'PubsSeven'; # The name of the database we are currently migrating
		    Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '50657';
			Settings=@{target = '1.1.3'};
            Flags=@('community'); # 'X','q','n','v','?','community','teams'
		},
		@{
		    Server = 'MySecondServer' # the name of the server
		    Database = 'PubsTwo'; # The name of the database we are currently migrating
		    Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '50657';
			Settings=@{target = '1.1.6'};
            Flags=@('community'); # 'X','q','n','v','?','community','teams'
		},
@{
			Server = 'MyThirdServer' # the name of the server
			Database = 'PubsOne'; # The name of the database we are currently migrating
			Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '1433';
			Settings=@{target = '1.1.6'};
		},
@{
			Server = 'MyThirdServer' # the name of the server
			Database = 'PubsSix'; # The name of the database we are currently migrating
			Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '1433';
			Settings=@{target = '1.1.6'};
		},
@{
			Server = 'MyFirstServer' # the name of the server
			Database = 'PubsFive'; # The name of the database we are currently migrating
			Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '1433';
			Settings=@{target = '1.1.4'};
            Actions=@('clean', 'migrate', 'info')
            Flags=@('q'); # 'X','q','n','v','?','community','teams'
		},
@{
			Server = 'MyThirdServer' # the name of the server
			Database = 'PubsThree'; # The name of the database we are currently migrating
			Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '1433';
			Settings=@{target = '1.1.3'};
		},
		@{
			Server = 'MyThirdServer' # the name of the server
			Database = 'PubsFour'; # The name of the database we are currently migrating
			Username = 'MyUserID' # only if you need username and password (no domain authentication)
			Port = '1433';
            Settings=@{target = '1.1.5'};
         }
	);
} 



$HistoryOfResults=@() #a powershell array of objects that stores the output of Flyway
<# turn the common args into commandline arguments #>
$CommonArgs=$configuration.GlobalSettings.GetEnumerator()|foreach{"-$($_.Name)=$($_.Value)"}
<# now iterate through all the databases #>
$configuration.Databases | foreach{ #for every database that you've specified ...
    $MyHistory=@() #have a new history for every database
    $currentObject=$_ #the object specifying the database and what to do with it
    $AnError=$False #assume the best
	$Server = $currentObject.Server # the name of the server
	$Database = $currentObject.Database; # The name of the database we are currently migrating
    #escape these names just in case they're used in a filepart as part of a name
    $EscapedDatabase=$Database.Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
    $EscapedServer=$Server.Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
    <# you only need this username and password if there is no domain authentication #>
	$username = $currentObject.Username;
	$Settings = $currentObject.Settings;
	$port = $currentObject.Port;
	$DataSource = $configuration.DataSource; #where you got the data from 
	# to describe the database for monitoring systems in an extended property
	$ProjectFolder = $configuration.ProjectFolder # where the migration scripts are stored
	# add a bit of error-checking. Is the project directory there
	if (-not (Test-Path "$ProjectFolder"))
	{ Write-warning "Sorry, but I couldn't find a project directory at the $ProjectFolder location";
      $AnError=$true }
	else { 
    # ...and is the script directory there?
	if (-not (Test-Path "$ProjectFolder\Scripts"))
	{ Write-warning "Sorry, but I couldn't find a scripts directory at the $ProjectFolder\Scripts location"
      $AnError=$true }}
      
	# now we get the password if necessary
	if ($username -ne '') #then it is using SQL Server Credentials
	{
		# we see if we've got these stored already
		$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($username)-$SourceServer.xml"
		# test to see if we know about the password in a secure string stored in the user area
		if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
		{
			#has already got this set for this login so fetch it
			$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
			
		}
		else #then we have to ask the user for it (once only)
		{
			# hasn't got this set for this login
			$SqlCredentials = get-credential -Credential $UserName
			# Save in the user area 
			$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
		}
		$Uid = $SqlCredentials.UserName;
		$Pwd = $SqlCredentials.GetNetworkCredential().password
		
		$FlyWayArgs = #create the basic details that Flyway needs
		@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database",
			"-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
			"-user=$($SqlCredentials.UserName)",
			"-password=$($SqlCredentials.GetNetworkCredential().password)")
	}
	else
	{
		$FlyWayArgs = #create the basic details that Flyway needs
		@("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true".
			"-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
	}
	$FlyWayArgs += $CommonArgs | forEach{ #Do any necessary macro substitution
        $_ -replace 
          '<database>', $EscapedDatabase -replace #the 'escaped' name of the database
          '<server>', $EscapedServer -replace #the 'escaped' name of the server (to make a legal filename)
          '<date>',(Get-Date).ToString('MM-dd-yyyy') -replace #the current date
          '<projectFolder>', $configuration.ProjectFolder #the path to the project folder
              }<# the project variables that we reference with placeholders #>
    if ($configuration.GlobalFlags -ne $null) #add any flags that are to be used for all databases
        {$FlyWayArgs += $configuration.GlobalFlags|foreach{"-$($_)"}};
    if ($currentObject.Flags -ne $null) #add any flags that are to be used for this database
        {$FlyWayArgs += $currentObject.Flags|foreach{"-$($_)"}};
    #work out whetherthe user has specified json output
    $WantsJSON= (($configuration.GlobalSettings.outputType -eq 'json') -or
                       ($Settings.outputType -eq 'json'))
    #now add all the settings

    $FlywayArgs+= $Settings.GetEnumerator()|foreach{"-$($_.Name)=$($_.Value)"}
 	If (-not ($AnError))
        {
        if ($CurrentObject.Actions.count -gt 0 )
            {
            $Myhistory+=$CurrentObject.Actions| #Do whatever action(s) you've specified 
                 foreach {flyway $_ @FlywayArgs| Join-PipelineStrings}
            }
        elseif ($configuration.GlobalActions.count -gt 0 )
            {
            $Myhistory+=$configuration.GlobalActions|#Do all the global action(s) 
                 foreach {flyway $_ @FlywayArgs| Join-PipelineStrings}
            }
        else {$Myhistory+=flyway info @FlywayArgs|Join-PipelineStrings}
        }
    else {Write-Warning "could not process job for $database on server $server"}
    if ($wantsJSON) #then add the returned flyway object to the array of objects
        {$HistoryOfResults += $MyHistory|convertfrom-json | #add the name of the server
           add-member -Type NoteProperty -PassThru -Name 'server' -Value $Server}
    $MyHistory |foreach{write-output "$($_)`n"} #output what flyway sent.
}
#the history of what happened should be in the $HistoryOfResults object. From this
#it is possible to generate a report of the outcomes. 

 

