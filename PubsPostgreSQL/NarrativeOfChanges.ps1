#Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-8.0.2\flyway.cmd' -Scope local
$FlywayCommand=(Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand) {
    throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0') {
    throw "Your Flyway Version is too outdated to work"
}
#specify the DSN, and create the ODVC connection

$ProjectFolder = 'S:\work\Github\PubsAndFlyway\PubsPostgreSQL'
$ErrorActionPreference = "Stop"
$DSNName = 'PostgreSQL'
$ConnPSQL = new-object system.data.odbc.odbcconnection
$ConnPSQL.ConnectionString = "DSN=$DSNName";
$ConnPSQL.Open()
#now use the information stored in the DSN to create the JDBC connection string for Flyway.
$parameters = (Get-OdbcDsn -name $DSNName).KeyValuePair |
where { $_.Key -in @('Database', 'Servername', 'Username', 'Port', 'Password') } |
foreach{ @{ $_.Key = "$($_.Value.Trim())".Trim() } }
@('Database', 'Servername', 'Port') | foreach{
	if ($parameters.$_ -ieq $NULL) { Write-Warning "the DSN didn't have the $_ " }
}
if ($parameters.Username -ne $null -and $parameters.Password -eq $null)
{ Write-Warning "the DSN didn't have the password " }

$versionPath = "$($env:USERPROFILE)\Documents\PolyGlotPubs\$DSNName\"
#we create a path to where we store the model and reports for each version
#This is separate from the project source as it is ephemeral

$TheArgs =
@("-locations=filesystem:$ProjectFolder\Scripts", <# the migration folder #>
	"-schemas=dbo,people")
$TheArgs += if ([string]::IsNullOrEmpty($parameters.Username))
{
	@("-url=jdbc:postgresql://$($parameters.Servername):$(
			$parameters.Port)/$($parameters.Database);integratedSecurity=true")
}
else
{
	@("-url=jdbc:postgresql://$($parameters.Servername):$($parameters.Port)/$($parameters.Database)",
		"-user=$($parameters.Username)",
		"-password=$($parameters.Password)")
}
#if this works we're probably good to go
Flyway @TheArgs info

#now we clean the database and do a new run of the migrations
Flyway @TheArgs clean # Drops all objects in the configured schemas for the Pubs database

<# now we iterate through the versions we've actually achieved, and after
doing each migration successfully, we can then store a model of the metadata
as a JSON file to disk in the $versionpath we've just defined #>

@('1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6') | foreach{
	$Version = $_;
	#first we check that the report directory exists for this version.
	if (-not (Test-Path -PathType Container "$:versionPath$Version"))
	{
		# does the path to the  directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force "$:versionPath$Version";
	}
	#Fine, so we do the migration
	Flyway @TheArgs migrate -target="$Version" # Migrates the database to a particular version
	if ($? -or $LASTEXITCODE -eq 1)
	{
		# we get a report of the metadata and save it as a json file that we can inspect
		#at our leisure and use as the basis of comparisons.
		Get-ODBCSourceMetadata  $connpsql -WantsComparableObject $true |
		ConvertTo-JSON > "$:versionPath\$Version\Model.json"
	}
	else
	{ Throw "migration at level $version failed" }
}

#Now we can gnerate a report for every migration but the first
$PreviousVersion = $null; #
@('1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6') | foreach{
	$Version = $_;
	if ($PreviousVersion -ne $null)
	{
		#see what is changed by comparing the models before and after the migration
		$Comparison = Diff-Objects -Parent 'Pubs' <#get the previous model from file#>`
		([IO.File]::ReadAllText("$:versionPath$PreviousVersion\Model.json") |
			ConvertFrom-JSON)<#and get the current model from file#> `
		([IO.File]::ReadAllText("$:versionPath$Version\Model.json") |
			ConvertFrom-JSON) |
		where { $_.match -ne '==' }
		$Comparison | Format-Table > "$:versionPath$Version\Changes.report"
		$Comparison | ConvertTo-JSON > "$:versionPath$Version\Changes.json"
		#we can do all sorts of more intutive reports from the output
	}
	$PreviousVersion = $Version;
}

@('1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6') | foreach{
	$Version = $_;
	$changes = ([IO.File]::ReadAllText("$:versionPath$Version\Changes.json")
	) | ConvertFrom-JSON
	$changes | foreach{
		$current = $_;
		switch ($current.Match)
		{
			'->' {
				"$(if ($current.Target -ne 'PSCustomObject')
					{ "Added '$($current.Target)' to" }
					else { "Added" }) '$($current.Ref) with version $version'" }
			'<>' {
				"Changed '$($current.Source)' to '$($current.Target
					)' at '$($current.Ref) with version $version'" }
			'<-' {
				"deleted '$($current.Source)' at '$($current.Ref
				    ) with version $version'" }
			default { "No metadata change in version $version'" }
		}
	}
}

