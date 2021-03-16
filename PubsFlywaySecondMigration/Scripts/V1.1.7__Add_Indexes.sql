/* add all missing indexes on foreign keys */

IF  (Object_Id('dbo.editions') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.editions'),'Publicationid_index','IndexID') IS NULL)
	CREATE INDEX Publicationid_index ON dbo.Editions(publication_id)
IF  (Object_Id('dbo.prices') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.prices'),'Editionid_index','IndexID') IS NULL)
	CREATE INDEX editionid_index ON dbo.prices(Edition_id)
IF  (Object_Id('dbo.Discounts') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.Discounts'),'Storid_index','IndexID') IS NULL)
	CREATE INDEX Storid_index ON dbo.Discounts(Stor_id)
IF  (Object_Id('dbo.TagTitle') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.TagTitle'),'Titleid_index','IndexID') IS NULL)
	CREATE INDEX Titleid_index ON dbo.TagTitle(title_id)
IF  (Object_Id('dbo.TagTitle') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.TagTitle'),'TagName_index','IndexID') IS NULL)
	CREATE INDEX TagName_index ON dbo.TagTitle(Tagname_id)
IF  (Object_Id('dbo.employee') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.employee'),'JobID_index','IndexID') IS NULL)
	CREATE INDEX JobID_index ON dbo.employee(Job_id)
IF  (Object_Id('dbo.employee') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.employee'),'pub_id_index','IndexID') IS NULL)
	CREATE INDEX pub_id_index ON dbo.employee(pub_id)
IF  (Object_Id('dbo.publications') IS NOT NULL
	AND IndexProperty(Object_Id('dbo.publications'),'pubid_index','IndexID') IS NULL)
	CREATE INDEX pubid_index ON dbo.publications(pub_id)

SELECT * FROM sys.indexes WHERE name LIKE '%index' and OBJECTPROPERTY(object_id,'IsSystemTable')=0
/*
Undo

IF  (IndexProperty(Object_Id('dbo.editions'),'Publicationid_index','IndexID') IS NOT NULL)
	DROP INDEX Publicationid_index ON dbo.editions
IF  (IndexProperty(Object_Id('dbo.prices'),'Editionid_index','IndexID') IS NOT NULL)
	DROP INDEX editionid_index ON dbo.prices
IF  (IndexProperty(Object_Id('dbo.Discounts'),'Storid_index','IndexID') IS NOT NULL)
	drop INDEX Storid_index ON dbo.Discounts
IF  (IndexProperty(Object_Id('dbo.TagTitle'),'Titleid_index','IndexID') IS NOT NULL)
	Drop INDEX Titleid_index ON dbo.TagTitle
IF  (IndexProperty(Object_Id('dbo.TagTitle'),'TagName_index','IndexID') IS NOT NULL)
	Drop INDEX TagName_index ON dbo.TagTitle
IF  (IndexProperty(Object_Id('dbo.employee'),'pub_id_index','IndexID') IS NOT NULL)
	Drop INDEX pub_id_index ON dbo.employee
IF  (IndexProperty(Object_Id('dbo.publications'),'pubid_index','IndexID') IS NOT NULL)
	Drop  INDEX pubid_index ON dbo.publications

*/
/*write the documentation to all the tables specified in the list that exist in the
database either writing to, or updating, what is there */
DECLARE @WhatToDocument TABLE (TheOrder INT IDENTITY, Tablename sysname, TheDescription NVARCHAR(4000));
INSERT INTO @WhatToDocument (Tablename, TheDescription)
VALUES
  ('dbo.authors', 'The authors of the publications. a publication can have one or more author'),
  ('dbo.discounts', 'These are the discounts offered by the sales people for bulk orders'),
  ('dbo.editions', 'A publication can come out in several different editions, of maybe a different type'),
  ('dbo.employee', 'An employee of any of the publishers'),
  ('dbo.jobs', 'These are the job descriptions and min/max salary level' ),
  ('dbo.prices', 'these are the current prices of every edition of every publication'),
  ('dbo.Sales', 'these are the sales of every edition of every publication'),
  ('dbo.pub_info', 'this holds the special information about every publisher'),
  ('dbo.publications', 'This lists every publication marketed by the distributor'),
  ('dbo.publishers', 'this is a table of publishers who we distribute books for'),
  ('dbo.roysched', 'this is a table of the authors royalty scheduleable'),
  ('dbo.stores', 'these are all the stores who are our customers'),
  ('dbo.TagName', 'All the categories of publications'),
  ('dbo.TagTitle', 'This relates tags to publications so that publications can have more than one'),
  ('dbo.titleauthor', 'this is a table that relates authors to publications, and gives their order of listing and royalty%');

DECLARE @ii INT, @iiMax INT; --the iterators
--the values fetched for each row
DECLARE @TableName sysname, @Schemaname sysname,
  @TheDescription NVARCHAR(4000),@Object_id int;
--initialise the iterator
SELECT @ii = 1, @iiMax = Max(TheOrder) FROM @WhatToDocument;

WHILE @ii <= @iiMax
  BEGIN
    SELECT @Schemaname = Object_Schema_Name(Object_Id(Tablename)),
      @TableName = Object_Name(Object_Id(Tablename)),
      @TheDescription = TheDescription,
	  @Object_id=Object_Id(TableName)
        FROM @WhatToDocument
        WHERE @ii = TheOrder;
      IF (@Object_id IS NOT NULL) --if the table exists
    IF NOT EXISTS --does the extended property exist?
      (
      SELECT 1
        FROM sys.fn_listextendedproperty
		  (N'MS_Description', N'SCHEMA',@Schemaname,
           N'TABLE',@TableName, null, null
          )
      )
      EXEC sys.sp_addextendedproperty @name = N'MS_Description',
        @value = @TheDescription, @level0type = N'SCHEMA',
        @level0name = @Schemaname, @level1type = N'TABLE',
        @level1name = @TableName;;
    ELSE
      EXEC sys.sp_updateextendedproperty @name = N'MS_Description',
        @value = @TheDescription, @level0type = N'SCHEMA',
        @level0name = @Schemaname, @level1type = N'TABLE',
        @level1name = @TableName;;
    SELECT @ii = @ii + 1; -- on to the next one
  END;
