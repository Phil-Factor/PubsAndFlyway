IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating schemas'
GO
CREATE SCHEMA [Classic]
AUTHORIZATION [dbo]
GO
PRINT N'Creating [dbo].[TagName]'
GO
CREATE TABLE [dbo].[TagName]
(
[TagName_ID] [int] NOT NULL IDENTITY(1, 1),
[Tag] [nvarchar] (100) NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [TagnameSurrogate] on [dbo].[TagName]'
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [TagnameSurrogate] PRIMARY KEY CLUSTERED  ([TagName_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[TagName]'
GO
ALTER TABLE [dbo].[TagName] ADD CONSTRAINT [Uniquetag] UNIQUE NONCLUSTERED  ([Tag])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[TagTitle]'
GO
CREATE TABLE [dbo].[TagTitle]
(
[TagTitle_ID] [int] NOT NULL IDENTITY(1, 1),
[title_id] [dbo].[tid] NOT NULL,
[Is_Primary] [bit] NOT NULL CONSTRAINT [NotPrimary] DEFAULT ((0)),
[TagName_ID] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_TagNameTitle] on [dbo].[TagTitle]'
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [PK_TagNameTitle] PRIMARY KEY CLUSTERED  ([title_id], [TagName_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

INSERT INTO TagName (Tag) SELECT DISTINCT type FROM titles;
PRINT N'adding tags and tagtitles'
INSERT INTO TagTitle (title_id,Is_Primary,TagName_ID)
  SELECT title_id, 1, TagName_ID FROM titles 
    INNER JOIN TagName ON titles.type = TagName.Tag;

IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [FK_TitlesPublishers]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [FK_TitleauthorTitles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK_salesTitles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] DROP CONSTRAINT [FK_RoySchedTitles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [GetPubidright]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [SurelyTheUSA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [UPKCL_titleidind]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [df_titletype]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [NowDefault]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [titleind] from [dbo].[titles]'
GO
DROP INDEX [titleind] ON [dbo].[titles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating types'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
CREATE TYPE [dbo].[Dollars] FROM numeric (9, 2) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Rebuilding [dbo].[titles]'
GO
CREATE TABLE dbo.temptitles
(
[title_id] [dbo].[tid] NOT NULL,
[title] [varchar] (80) NOT NULL,
[pub_id] [char] (8) NULL,
[price] [dbo].[Dollars] NULL,
[advance] [dbo].[Dollars] NULL,
[royalty] [int] NULL,
[ytd_sales] [int] NULL,
[notes] [varchar] (200) NULL,
[pubdate] [datetime] NOT NULL CONSTRAINT [NowDefault] DEFAULT (getdate())
)
GO

IF @@ERROR <> 0 SET NOEXEC ON
GO
INSERT INTO dbo.temptitles([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate]) SELECT [title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate] FROM [dbo].[titles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DROP TABLE [dbo].[titles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'temptitles', N'titles', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [UPKCL_titleidind] on [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [UPKCL_titleidind] PRIMARY KEY CLUSTERED  ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [titleind] on [dbo].[titles]'
GO
CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles] ([title])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Classic].[titles]'
GO
CREATE VIEW [Classic].[titles]
AS
SELECT titles.title_id, titles.title, Coalesce(TN.Tag, 'Undecided') AS type,
  titles.pub_id, titles.price, titles.advance, titles.royalty,
  titles.ytd_sales, titles.notes, titles.pubdate
  FROM dbo.titles AS titles
    LEFT OUTER JOIN dbo.TagTitle Tagtitle
      ON TagTitle.title_id = titles.title_id
    INNER JOIN dbo.TagName AS TN
      ON TN.TagName_ID = TagTitle.TagName_ID
  WHERE TagTitle.Is_Primary = 1;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[byroyalty]'
GO
ALTER PROCEDURE [dbo].[byroyalty] @percentage INT
AS
  BEGIN
    SELECT titleauthor.au_id
      FROM dbo.titleauthor AS titleauthor
      WHERE titleauthor.royaltyper = @percentage;
  END;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[reptq1]'
GO
ALTER PROCEDURE [dbo].[reptq1]
AS
  BEGIN
    SELECT CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      Avg(titles.price) AS avg_price
      FROM dbo.titles AS titles
      WHERE titles.price IS NOT NULL
      GROUP BY titles.pub_id WITH ROLLUP
      ORDER BY pub_id;
  END;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[reptq2]'
GO
ALTER PROCEDURE [dbo].[reptq2]
AS
  BEGIN
    SELECT CASE WHEN Grouping(TN.tag) = 1 THEN 'ALL' ELSE TN.Tag END AS type,
      CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      Avg(titles.ytd_sales) AS avg_ytd_sales
      FROM dbo.titles AS titles
        INNER JOIN dbo.TagTitle AS TagTitle
          ON TagTitle.title_id = titles.title_id
        INNER JOIN dbo.TagName AS TN
          ON TN.TagName_ID = TagTitle.TagName_ID
      WHERE titles.pub_id IS NOT NULL AND TagTitle.Is_Primary = 1
      GROUP BY titles.pub_id, TN.Tag WITH ROLLUP;
  END;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[reptq3]'
GO
ALTER PROCEDURE [dbo].[reptq3] @lolimit dbo.Dollars, @hilimit dbo.Dollars,
  @type CHAR(12)
AS
  BEGIN
    SELECT CASE WHEN Grouping(titles.pub_id) = 1 THEN 'ALL' ELSE titles.pub_id END AS pub_id,
      CASE WHEN Grouping(TN.tag) = 1 THEN 'ALL' ELSE TN.Tag END AS type,
      Count(titles.title_id) AS cnt
      FROM dbo.titles AS titles
        INNER JOIN dbo.TagTitle AS TagTitle
          ON TagTitle.title_id = titles.title_id
        INNER JOIN dbo.TagName AS TN
          ON TN.TagName_ID = TagTitle.TagName_ID
      WHERE titles.price > @lolimit
        AND TagTitle.Is_Primary = 1
        AND titles.price < @hilimit
        AND TN.Tag = @type
         OR TN.Tag LIKE '%cook%'
      GROUP BY titles.pub_id, TN.Tag WITH ROLLUP;
  END;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [GetPubidright] CHECK (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [godsOwnCountry] DEFAULT ('USA') FOR [country]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[TagTitle]'
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [fkTagname] FOREIGN KEY ([TagName_ID]) REFERENCES [dbo].[TagName] ([TagName_ID])
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [FKTitle_id] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [FK_TitlesPublishers] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [FK_RoySchedTitles] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_salesTitles] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK_TitleauthorTitles] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	PRINT 'The database update failed'
END
GO
