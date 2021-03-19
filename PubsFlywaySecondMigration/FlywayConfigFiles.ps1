function Join-PipelineStrings
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[string]$String,
		[Parameter(Position = 1)]
		[string]$Delimiter = "`n"
	)
	BEGIN { $items = @() }
	PROCESS { $items += $String }
	END { return ($items -join $Delimiter) }
}

# flyway -? #get help! 
#create an alias for the commandline Flyway, 
Set-Alias Flyway  "$env:ChocolateyInstall\lib\flyway.commandline\tools\flyway-7.3.1\flyway.cmd" -Scope local
# and here are our project details. The project folder
$configuration = @{
	# to describe the database for monitoring systems and reporting
	'ProjectFolder' = 'MyPathTo\PubsFlywaySecondMigration'; # where the migration scripts are stored
	'ConfDirectory' = "$env:USERPROFILE\FlywayConf\*.conf"
	'GlobalSettings' = @{
		'outputType' = 'json';
		'outputFile' = '<projectFolder>\Reports\<server><database>.json'; #the macros in angle brackets get filled in 
		# the outputfile you can specify the current database with the macro <database>, likewise <server> and <date> 
		'placeholders.ProjectName' = 'Publications'; # this gets used for reporting
		'placeholders.ProjectDescription' = 'A sample project to show how to build a database and fill it with data';
		'placeholders.Datasource' = 'Pubs'
	}
	'GlobalActions' = @('clean', 'migrate', 'info'); #a list of flyway actions you wish to perform, in order
    <# emigrate, clean, info, validate, undo, baseline or repair #>
	'GlobalFlags' = @('community'); # 'X','q','n','v','?','community','teams'
	
}

$ProjectFolder = $configuration.ProjectFolder # where the migration scripts are stored
$HistoryOfResults = @() #a powershell array of objects that stores the output of Flyway
<# turn the common args into commandline arguments #>
$CommonArgs = $configuration.GlobalSettings.GetEnumerator() | foreach{ "-$($_.Name)=$($_.Value)" }
$AnError = $false
if (-not (Test-Path "$ProjectFolder"))
{
	Write-warning "Sorry, but I couldn't find a project directory at the $ProjectFolder location";
	$AnError = $true
}
else
{
	# ...and is the script directory there?
	if (-not (Test-Path "$ProjectFolder\Scripts"))
	{
		Write-warning "Sorry, but I couldn't find a scripts directory at the $ProjectFolder\Scripts location"
		$AnError = $true
	}
}

<# now iterate through all the databases #>
if ($anError -eq $false)
{
	dir "$($configuration.ConfDirectory)" -File |
	foreach{
		# for every database confog file that you've specified ...
		$fullname = $_.FullName
		$FlywayArgs = @();
		$FlywayArgs += "-configFiles=$fullname"
		$Server = $_.Basename.Split('-')[0] # the name of the server
		$Database = $_.Basename.Split('-')[1] # The name of the database we are currently migrating
		$MyHistory = @() #have a new history for every database
        Write-warning "Doing $Database on $Server"
		$AnError = $False #assume the best
		#escape these names just in case they're used in a filepart as part of a name
		$EscapedDatabase = $Database.Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
		$EscapedServer = $Server.Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
		$FlyWayArgs += $CommonArgs | forEach{
			#Do any necessary macro substitution
			$_ -replace
			'<database>', $EscapedDatabase -replace #the 'escaped' name of the database
			'<server>', $EscapedServer -replace #the 'escaped' name of the server (to make a legal filename)
			'<date>', (Get-Date).ToString('MM-dd-yyyy') -replace #the current date
			'<projectFolder>', $configuration.ProjectFolder #the path to the project folder
		}<# the project variables that we reference with placeholders #>
		if ($configuration.GlobalFlags -ne $null) #add any flags that are to be used for all databases
		{ $FlyWayArgs += $configuration.GlobalFlags | foreach{ "-$($_)" } };
		#work out whetherthe user has specified json output
		$WantsJSON = (($configuration.GlobalSettings.outputType -eq 'json') -or
			($Settings.outputType -eq 'json'))
		#now add all the settings
		$FlywayArgs += $Settings.GetEnumerator() | foreach{ "-$($_.Name)=$($_.Value)" }
		If (-not ($AnError))
		{
			if ($configuration.GlobalActions.count -gt 0)
			{
				$Myhistory += $configuration.GlobalActions | #Do all the global action(s) 
				foreach { flyway $_ @FlywayArgs | Join-PipelineStrings }
			}
			else { $Myhistory += flyway info @FlywayArgs | Join-PipelineStrings }
		}
		else { Write-Warning "could not process job for $database on server $server" }
		if ($wantsJSON) #then add the returned flyway object to the array of objects
		{
			$MyHistoryAsPSObject = $MyHistory | convertfrom-json
			$CurrentVersion = 'unknown'
			$MyHistoryAsPSObject.GetEnumerator() |
			  where { gm -InputObject $_ -Name 'Schemaversion' } |
			    foreach{ $CurrentVersion = $_.SchemaVersion }
			add-member -InputObject $MyHistoryAsPSObject -Type NoteProperty -PassThru -Name 'server' -Value $Server
			add-member -InputObject $MyHistoryAsPSObject -Type NoteProperty -PassThru -Name 'CurrentVersion' -Value $CurrentVersion
			$HistoryOfResults += $MyHistoryAsPSObject
		}
		$MyHistory | foreach{ write-output "$($_)`n" } #output what flyway sent.
	}
	#the history of what happened should be in the $HistoryOfResults object. From this
	#it is possible to generate a report of what happened. 
	$HistoryOfResults | where { $_.error -ne $null } |
	foreach{ Write-error "On $($_.server) $($_.error.message)" }
	$HistoryOfResults | where { $_.warnings.Count -gt 0 } -OutVariable Result |
	foreach{ $_.warnings } |
	foreach{ Write-warning "$($Result.Operation) on $($Result.database): $($_)" }
}


    