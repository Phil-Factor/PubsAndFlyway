. '.\preliminary.ps1'


<#
@('1.1.1','1.1.2','1.1.3','1.1.4',
'1.1.5','1.1.6','1.1.7','1.1.8',
'1.1.9','1.1.10','1.1.11')| foreach{
Flyway @FlywayUndoArgs migrate "-target=$_"
}
#>

#if this works we're probably good to go

Flyway @FlywayUndoArgs info -teams
Flyway @FlywayUndoArgs clean -teams
Flyway @FlywayUndoArgs migrate '-target=1.1.5'
Flyway @FlywayUndoArgs undo '-target=1.1.5'


$GetCurrentVersion.Invoke($Details)
