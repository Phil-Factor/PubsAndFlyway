<#
The tasks are in a separate script. It is placed in the same directory as this 
script.
First, find out where we were executed from. Each environment has a different way
of doing it. It all depends how you execute it. If you just past this in, you'll
have to make this the working directory #>
try
{
	$executablepath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
}
catch { $executablepath = '' } #didn't like that so remove it
if ($executablepath -eq '')
{
	$executablepath = "$(If ($psISE) # null if at the commandline
		{ Split-Path -Path $psISE.CurrentFile.FullPath }
		Else { $global:PSScriptRoot })"
}
if ([string]::IsNullOrEmpty($ExecutablePath)) { $ExecutablePath = $pwd }
.("$executablepath\DatabaseBuildAndMigrateTasks.ps1")

$DatabaseDetails = @{
	'pwd' = ''; #Always leave blank
	'uid' = 'PhilFactor' #leave blank unless you use credentials
	; 'Database' = 'PubsOne'; # fill this in please
	; 'server' = 'Philf01'; # We need to know the server!
	; 'port' = $null; #Not normally needed with SQL Server. add if required
	#set to $null or leave it out if you want to let jdbc detect it 
	'Project' = 'testing'; # the name of the project-needed for saving files
	'Version' = ''; # current version of database - 
	# leave blank unless you know
	'Checked' = $false; # has it been checked against a source directory?
	'Problems' = @();
	'Warnings' = @()
}
# some values, especially server names, have to be escaped when used in file paths.
if ($DatabaseDetails.Escapedserver -eq $null)
{
	$EscapedValues = $DatabaseDetails.GetEnumerator() | 
       where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
		 @{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
	}
}
$EscapedValues | foreach{ $DatabaseDetails += $_ }
$WhatWasReturned = '';
$Invocations = @($FetchAnyRequiredPasswords, $GetCurrentVersion, $CheckCodeInDatabase)
$Invocations | foreach{ if ($DatabaseDetails.Problems.Count -eq 0) { $WhatWasReturned += $_.Invoke($DatabaseDetails) } }
$OurProblems = ''
if ($DatabaseDetails.Problems.Count -gt 0)
{
	$ourProblems = $DatabaseDetails.Problems | foreach{ $TheName = $_.name; $_.Issues } | foreach{ "$($TheName): $_" }
	Write-warning "We hit a problem with $($ourProblems -join '-')"
}
if ($DatabaseDetails.Warnings.Count -gt 0)
{
	$ourwarnings = $DatabaseDetails.Warnings | foreach{ $TheName = $_.name; $_.Issues } | foreach{ "$($TheName): $_" }
	Write-output "We had a Warning with $($ourWarnings -join "`n")"
}

