<#
V1.1.12 is reserved to import data for provisioned scripts. This is a copy of a generic script
that will BCP Data in or out for any version. It merely sets the fact that it is doing the
Input operation

The generic script is designed to run within Flyway
It will transfer data to the current SQL Server database using the data saved for this version. 
This is done to allow rapid provisioning of extra copies of the database.
If the destination has a different table structure from the database that provided the source
then you'll get an error.
BCP needs to be installed to run this. This comes with SSMS so you probably
have it already. Sometimes you need to create an alias for BCP but I think that
problem has gone away.
All interaction with the database is do via SQLCMD just to keep things simple.

This routine checks the current version of the database and takes data from an
appropriate data store from a data directory that is a sibling folder to the scripts
directory.
#>
$DataDirection = 'in'; #set this to In or Out
# set "Option Explicit" to catch subtle errors
set-psdebug -strict
$ErrorActionPreference = "stop" # we stagger on, bleeding, where possible if an error occurs

$GetdataFromSQLCMD = {<# a Scriptblock way of accessing SQL Server via a CLI to get JSON results without having to 
explicitly open a connection. #>
	Param ($Theargs,
		$query)
	$TempFile = "$($env:Temp)\TempOutput.json"
	$TempInputFile = "$($env:Temp)\TempInput.sql"
	$FullQuery = "$query"
	if ($FullQuery -like '*"*')
	{ #Then we can't pass a query as a string. It must be passed as a file
		$FullQuery>$TempInputFile;
		if ($TheArgs.User -ne $null) #if we need to use credentials
		{
			sqlcmd -S $TheArgs.server -d $TheArgs.database `
				   -i $TempInputFile -U $TheArgs.User -P $TheArgs.password `
				   -o "$TempFile" -u -y0
		}
		else #we are using integrated security
		{
			sqlcmd -S $TheArgs.server -d $TheArgs.database `
				   -i $TempInputFile -E -o "$TempFile" -u -y0
		}
		Remove-Item $TempInputFile
	}
	
	else #we can pass a query as a string
	{
		if ($TheArgs.User -ne $null) #if we need to use credentials
		{
			sqlcmd -S $TheArgs.server -d $TheArgs.database `
				   -Q "`"$FullQuery`"" -U $TheArgs.User -P $TheArgs.password `
				   -o `"$TempFile`" -u -y0
		}
		else #we are using integrated security
		{
			sqlcmd -S $TheArgs.server -d $TheArgs.database `
				   -Q "`"$FullQuery`"" -o `"$TempFile`" -u -y0
		}
	}
	If (Test-Path -Path $TempFile)
	{ #make it easier for the caller to read the error
		$response = [IO.File]::ReadAllText($TempFile);
		Remove-Item $TempFile
		if ($response -like 'Msg*')
		{ "[{`"Error`":`"$($TheArgs.database) says $Response'`"}]" }
		elseif ($response -like 'SqlCmd*')
		{ "[{`"Error`":`"SQLCMD says $Response'`"}]" }
		elseif ($response -like 'NULL*')
		{ '' }
		else
		{ $response }
	}
}

$WeCanContinue = $true #so far but who knows?
$internalLog = @("$(Get-date)- started BCP $DataDirection  with $env:FLYWAY_USER and $env:FLYWAY_URL")

#our regex for gathering variables from Flyway's URL
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w]{1,20}):(?<port>[\d]{1,4}|)(;.+databaseName=|/)(?<database>[\w]{1,20})'
$FlywayURLTruncationRegex = 'jdbc:.{1,30}://.{1,30}(;|/)'
#this FLYWAY_URL contains the current database, port and server so
# it is worth grabbing
$ConnectionInfo = $env:FLYWAY_URL #get the environment variable
if ($ConnectionInfo -eq $null) #OMG... it isn't there for some reason
{ $internalLog += 'missing value for flyway url'; $WeCanContinue = $false; }

$UserName = $env:FLYWAY_USER;
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
	$internalLog += 'unmatched connection info'
	$weCanContinue = $false;
}
$internalLog += "BCP $direction with RDBMS=$RDBMS, Server='$server' Port='$port' and Database= '$database'"

if ($weCanContinue)
{
	# now we get the password if necessary
	if ($username -ne '' -and $RDBMS -ne 'sqlite') #then it is using Credentials
	{
		
		# we see if we've got these stored already
		$SqlEncryptedPasswordFile = "$env:USERPROFILE\$($UserName)-$Server-$($RDBMS).xml"
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
		$user = "$($SqlCredentials.UserName)";
		$password = "$($SqlCredentials.GetNetworkCredential().password)";
	}
	$SQLCmdArgs = @{
		'Server' = $Server; 'Database' = $Database; 'User' = $SqlCredentials.UserName;
		'Password' = $SqlCredentials.GetNetworkCredential().password
	}
	
	$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
	$internalLog = @()
	
	$FilePath = '..\Data'
	
} #Now finished getting credentials. Is the data directory there
if (!(Test-Path -path $Filepath -PathType Container))
{
	if ($DataDirection -eq 'Out')
	{
		$Null=New-Item -ItemType Directory -Path $FilePath -Force
		$internalLog += "the BCP Directory doesn't exist";
	}
	else
	{
		$internalLog += 'No appropriate directory with BCP files yet';
		$weCanContinue = $false;
	}
}
# now get the current version of the database   
$Result = $GetdataFromSQLCMD.Invoke($SQLCmdArgs, @'
Set nocount on;
SELECT version from dbo.flyway_schema_history WHERE installed_rank=(
            SELECT Max(installed_rank) from dbo.flyway_schema_history WHERE success=1)
            for JSON auto
'@)|Convertfrom-json
if ($Result.error -ne $null)
{
	$internalLog += $Tables.Error;
	$weCanContinue = $false;
}
else
{$version = $Result.version}
$internalLog += "Database was at version '$version'";
$version='1.1.12'
if (!(Test-Path -path "$Filepath\$version" -PathType Container))
{
	if ($Datadirection -eq 'Out')
	{
		$null=New-Item -ItemType Directory -Path "$Filepath\$version" -Force
		$internalLog += "the BCP version Directory doesn't exist";
	}
	else
	{
		$internalLog += "No appropriate directory for $Version with BCP files yet";
		$weCanContinue = $false;
	}
}


if ($weCanContinue)
{
	#now we know the version we get a list of the tables.
	$Tables = $GetdataFromSQLCMD.Invoke($SQLCmdArgs, @"
SET NOCOUNT ON;
DECLARE @json NVARCHAR(MAX);
SELECT @json =
  (SELECT Object_Schema_Name (object_id) AS [Schema], name
     FROM sys.tables
     WHERE
     is_ms_shipped = 0 AND name NOT LIKE 'Flyway%'
  FOR JSON AUTO);
SELECT @json;
"@)|ConvertFrom-Json
	Write-verbose "Reading data in from $DirectoryToLoadFrom"
	if ($Tables.Error -ne $null)
	{
		$internalLog += $Tables.Error;
		$weCanContinue = $false;
	}
}


if ($DataDirection -eq 'In')
    {$Result = $GetdataFromSQLCMD.Invoke($SQLCmdArgs, @'
    EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
'@)
    };

if ($weCanContinue)
{
    $directory = "$Filepath\$($version.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')";
	$Tables |
	foreach {
		# calculate where it gotten from #
		$filename = "$($_.Schema)_$($_.Name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_';
		$progress = '';
		Write-Verbose "Reading $DataDirection $filename from $($directory)\$filename.bcp"
		if ($User -ne '') #using standard credentials 
		{
			if ($DataDirection -eq 'Out') #Reading out the data using credentials
			{
				$Progress = BCP "$($_.Schema).$($_.Name)"  out  "$directory\$filename.bcp"  `
								-n "-d$($Database)"  "-S$($server)"  `
								"-U$user" "-P$password"
			}
			else #Reading in the data using credentials
			{
				$Progress = BCP "$($_.Schema).$($_.Name)" in "$directory\$filename.bcp" -q -n -E `
								"-U$($user)"  "-P$password" "-d$($Database)" "-S$server"
            }
		}
		else #using windows authentication
		{ #-E Specifies that identity value or values in the imported data are to be used
			if ($DataDirection -eq 'Out') #Reading out the data via windows auth
			{
				$Progress = BCP "$($_.Schema).$($_.Name)"  out  "$directory\$filename.bcp"  `
								-n "-d$($Database)"  "-S$($server)"
			}
			else #Reading in the data via windows auth
			{
				$Progress = BCP "$($_.Schema).$($_.Name)" in "$directory\$filename.bcp" -q -n -E `
								"-d$($Database)" "-S$server"
			}
		}
		if (-not ($?) -or $Progress -like '*Error*') # if there was an error
		{
			throw ("Error with data import  of $($directory)\$($_.Schema)_$($_.Name).bcp - $Progress ");
		}
	}

if ($DataDirection -eq 'In')
    {$Result = $GetdataFromSQLCMD.Invoke($SQLCmdArgs, @'
ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all
'@)
    }
}
#write to the Flyway output if anything went wrong.
if (!($weCanContinue)) { $internalLog | foreach{ Write-warning $_ } }
#write it to the log
$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
"It has been my pleasure to Bulk-copy this data in, Master. "
