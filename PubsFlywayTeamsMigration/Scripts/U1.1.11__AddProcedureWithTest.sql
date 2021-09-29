IF Object_Id ('[dbo].[SplitStringToWords]', 'TF') IS NOT NULL
  BEGIN
    PRINT N'Dropping [dbo].[SplitStringToWords]';
    DROP FUNCTION [dbo].[SplitStringToWords];
  END;
PRINT N'Altering extended properties';
GO
DECLARE @Version NVARCHAR(10) = N'1.1.10';
DECLARE @Database NVARCHAR(3000);
SELECT @Database = N'${flyway:database}';
DECLARE @DatabaseInfo NVARCHAR(3000) =
          (SELECT @Database AS "Name", @Version AS "Version",
                  N'${projectDescription}' AS "Description",
                  N'${projectName}' AS "Project", GetDate () AS "Modified",
                  SUser_Name () AS "by"
          FOR JSON PATH);
IF NOT EXISTS
  (SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
     FROM
     sys.fn_listextendedproperty (
       N'Database_Info', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) )
  EXEC sys.sp_addextendedproperty @name = N'Database_Info',
                                  @value = @DatabaseInfo;
ELSE
  EXEC sys.sp_updateextendedproperty @name = N'Database_Info',
                                     @value = @DatabaseInfo;

