DECLARE @TheErrorNumber INT
SELECT @TheErrorNumber=0
 BEGIN TRY
      EXECUTE sp_executesql  @stmt = N'SELECT String_Agg(text,'','') FROM (VALUES (''testing''),(''testing''),(''one''),(''Two''),(''three''))f(Text)'
    END TRY
    BEGIN CATCH
       SELECT @TheErrorNumber=Error_Number() 
    END CATCH;
/*On Transact SQL language the Msg 195 Level 15 - 'Is not a recognized built-in function name'
 means that the function name is misspelled, not supported  or does not exist. */
IF @TheErrorNumber = 0 
	BEGIN
	EXECUTE sp_executesql  @stmt = N'
ALTER VIEW [dbo].[TitlesAndEditionsByPublisher]
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/
SELECT publishers.pub_name AS publisher, title,
  String_Agg
    (
    Publication_type + '' ($'' + Convert(VARCHAR(20), price) + '')'', '', ''
    ) AS ListOfEditions
  FROM dbo.publishers
    INNER JOIN dbo.publications
      ON publications.pub_id = publishers.pub_id
    INNER JOIN editions
      ON editions.publication_id = publications.Publication_id
    INNER JOIN dbo.prices
      ON prices.Edition_id = editions.Edition_id
  WHERE prices.PriceEndDate IS NULL
  GROUP BY publishers.pub_name, title;'
  END
ELSE
EXECUTE sp_executesql  @stmt = N'
ALTER VIEW [dbo].[TitlesAndEditionsByPublisher]
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/
SELECT publishers.pub_name AS publisher, title,
	Stuff ((SELECT '', ''+Publication_type + '' ($'' + Convert(VARCHAR(20), price) + '')''
    FROM  editions
    INNER JOIN dbo.prices
      ON prices.Edition_id = editions.Edition_id
  WHERE prices.PriceEndDate IS NULL
  and editions.publication_id = publications.Publication_id
    FOR XML PATH(''''), TYPE).value(''.'', ''nvarchar(max)''),1,2,'''') AS ListOfEditions
  FROM dbo.publishers
    INNER JOIN dbo.publications	
	ON publications.pub_id = publishers.pub_id
'
	
SELECT installed_rank, [version], [description], success FROM dbo.flyway_schema_history;