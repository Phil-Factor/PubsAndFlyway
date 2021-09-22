#create an alias for the commandline Flyway and SQLite, 
Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-7.15.0\flyway.cmd' -Scope local
Set-Alias SQLite  'C:\ProgramData\chocolatey\lib\SQLite\tools\sqlite-tools-win32-x86-3360000\sqlite3.exe' -Scope local
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$WeCanContinue = $true
$internalLog = @("$(Get-date)- started with $env:FLYWAY_USER and $env:FLYWAY_URL")
#our regex for gathering variables from Flyway's URL
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w]{1,20})(?<port>:[\d]{1,4}|)(;.+databaseName=|/)(?<database>[\w]{1,20})'
$FlywayURLTruncationRegex = 'jdbc:.{1,30}://.{1,30}(;|/)'

$schemas= $env:FP__schemas__

#this FLYWAY_URL contains the current database, port and server so
# it is worth grabbing
$ConnectionInfo = $env:FLYWAY_URL #get the environment variable
if ($ConnectionInfo -eq $null) #OMG... it isn't there for some reason
{ $internalLog += 'missing value for flyway url'; $WeCanContinue = $false; }

$uid = $env:FLYWAY_USER;
$ProjectFolder = $PWD.Path;

if ($ConnectionInfo -imatch $FlywayURLRegex)
{
	#we can extract all the info we need
	$RDBMS = $matches['RDBMS'];
	$server = $matches['server'];
	$port = $matches['port'];
	$database = $matches['database']
}
elseif ($ConnectionInfo -imatch 'jdbc:(?<RDBMS>[\w]{1,20}):(?<database>[\w:\\]{1,80})')
{
	#no server or port
	$RDBMS = $matches['RDBMS'];
	$server = 'LocalHost';
	$port = 'default';
	$database = $matches['database']
}
else
{
	$internalLog += 'unmatched connection info'; $WeCanContinue = $false;
}

$internalLog += "RDBMS=$RDBMS, Server='$server' Port='$port', User='$username', schemas='$schemas' and Database= '$database'"
if ($weCanContinue)
{
	# now we get the password if necessary
	if ($username -ne '' -and $RDBMS -ne 'sqlite') #then it is using Credentials
	{
		# we see if we've got these stored already
		$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($uid)-$Server-$($RDBMS).xml"
		# test to see if we know about the password in a secure string stored in the user area
		if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
		{
			#has already got this set for this login so fetch it
			$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
			
		}
		else #then we have to ask the user for it (once only)
		{
			# hasn't got this set for this login
			$SqlCredentials = get-credential -Credential $uid
			# Save in the user area 
			$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
		}
		$FlyWayArgs =
		@("-url=$ConnectionInfo",
			"-locations=filesystem:$PWD", <# the migration folder #>
			"-user=$($SqlCredentials.UserName)",
			"-password=$($SqlCredentials.GetNetworkCredential().password)"
         )
	}
	else
	{
		$FlyWayArgs =
        @("-url=$($ConnectionInfo)$(if ($RDBMS -eq 'sqlserver'){'integratedSecurity=true'}else {''})",
			"-locations=filesystem:$PWD"
          )<# the migration folder #>
	}
    if ($RDBMS -ne 'sqlite')
        {if ($schemas -eq $null) 
            {$internalLog += 'missing value for schemas'; $WeCanContinue = $false;}
        else{   
        $FlywayArgs+="-schemas=$schemas"}
        };
	$internalLog += "running Flyway with $FlyWayArgs";
	$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
	$internalLog = @()
	
	#get a JSON report of the history. We only want the record for the current version
	$report = Flyway info  @FlywayArgs -outputType=json | convertFrom-json
	if ($report.error -ne $null) #if an error was reported by Flyway
	{
		#if an error (usually bad parameters) error out.
		$report.error | foreach { $internalLog += "$($_.errorCode): $($_.message)" };
        break;
	}
	if ($report.allSchemasEmpty) #if it is an empty database
	{ $internalLog += "all schemas of $database are empty. No version has been created here" }
	else
	{
		#looking good, so first get the paramaters that are not specific to the version
		$RecordOfCurrentVersion = [pscustomobject]@{
			# get the global variables
			'Database' = $report.database;
			'Server' = $server;
			'RDBMS' = $RDBMS;
			'Schema names' = $report.schemaName;
			'Flyway Version' = $report.flywayVersion;
		}
	} # now add all the values from the record for the current version
	$Report.migrations |
	where { $_.version -eq $Report.schemaVersion } | foreach{
		$rec = $_; #remember this for gettinmg it's value
		$rec | gm -MemberType NoteProperty
	} | foreach{
		# do each key/value pair in turn
		$RecordOfCurrentVersion |
		Add-Member -MemberType NoteProperty -Name $_.Name -Value $Rec.($_.Name)
	}
	if ($RecordOfCurrentVersion.state -ne 'Success')
	{ $internalLog += "Have you given the correct project folder?" }
	#now all we have to do is to write it into the database if the record
	#does not already exist
	$internalLog += "Now saving $($RecordOfCurrentVersion) to SQLite"
	$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
	$internalLog = @()
	#in this case, we have only one record but we'll use a pipeline
	#just for convenience.
	$RecordOfCurrentVersion | foreach{
		sqlite "$(Split-Path  $PWD -Parent)\flywayHistory.db"  @"

CREATE TABLE IF NOT EXISTS 
Versions(
    Database Varchar(80),
    Server Varchar(80),
    RDBMS  Varchar(20),
    Schema_names Varchar(200),
    Flyway_Version Varchar(20),
    category Varchar(80),
    description Varchar(80),
    executionTime int,
    filepath  Varchar(200),
    installedBy Varchar(80),
    installedOn Varchar(25),
    installedOnUTC Varchar(25),
    state Varchar(80),
    type Varchar(10),
    undoable Varchar(5),
    version Varchar(80),
    PRIMARY KEY (Database, Server, RDBMS, Version))
;
INSERT INTO Versions( Database, Server, RDBMS, Schema_names,
Flyway_Version, category, description, executionTime,
filepath, installedBy, installedOn, installedOnUTC,
state, type, undoable, version) 
SELECT '$($_.Database)', '$($_.Server)', '$($_.RDBMS)', 
  '$($_.'Schema names')', '$($_.'Flyway Version')', '$($_.category)',
  '$($_.description)', '$($_.executionTime)', '$($_.filepath)',
  '$($_.installedBy)', '$($_.installedOn)', '$($_.installedOnUTC)',
  '$($_.state)', '$($_.type)', '$($_.undoable)', '$($_.version)'
WHERE NOT EXISTS(SELECT 1 FROM Versions
        WHERE Database='$($_.Database)' AND Server= '$($_.Server)' 
        AND RDBMS= '$($_.RDBMS)' AND version = '$($_.Version)'); 
"@  .exit
        }
     if ($LASTEXITCODE -ne 0){
        $InternalLog +="SQLite reurned error code $LASTEXITCODE"
        }
$InternalLog +="Saved record to $(Split-Path  $PWD -Parent)\flywayHistory.db"
}
else
{ $internalLog += "$(Get-date)- had to abandon reporting" }

$internalLog | foreach{ "Logged $_" }
$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log"
 }
