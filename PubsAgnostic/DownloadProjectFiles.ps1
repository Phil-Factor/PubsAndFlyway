$ProjectFolder="$env:Temp\PubsAndFlyway\PubsAgnostic";
$Params = @{
    'Owner' = 'Phil-Factor';
    'Repository' = 'PubsAndFlyway';
    'RepoPath' = 'PubsAgnostic';
    'DestinationPath' = $ProjectFolder
}
Get-FilesFromRepo @Params
