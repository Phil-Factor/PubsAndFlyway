/****** Object:  UserDefinedDataType [dbo].[Dollars]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [dbo].[Dollars] FROM [numeric](9, 2) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[empid]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [dbo].[empid] FROM [char](9) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[id]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [dbo].[id] FROM [varchar](11) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tid]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [dbo].[tid] FROM [varchar](6) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalAddressline]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalAddressline] FROM [varchar](60) NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalCVC]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalCVC] FROM [char](3) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalEmailAddress]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalEmailAddress] FROM [nvarchar](40) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalLocation]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalLocation] FROM [varchar](20) NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalName]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalName] FROM [nvarchar](40) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalNote]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalNote] FROM [nvarchar](max) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalPaymentCardNumber]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalPaymentCardNumber] FROM [varchar](20) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalPhoneNumber]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalPhoneNumber] FROM [varchar](20) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalPostalCode]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalPostalCode] FROM [varchar](15) NOT NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalSuffix]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalSuffix] FROM [nvarchar](10) NULL
GO
/****** Object:  UserDefinedDataType [people].[PersonalTitle]    Script Date: 20/09/2021 10:11:16 ******/
CREATE TYPE [people].[PersonalTitle] FROM [nvarchar](10) NOT NULL
GO
/****** Object:  UserDefinedFunction [dbo].[SplitStringToWords]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitStringToWords] (@TheString NVARCHAR(MAX))
/**
Summary: >
  This table function takes a string of text and splits it into words. It
  takes the approach of identifying spaces between words so as to accomodate
  other character sets
Author: Phil Factor
Date: 27/05/2021

Examples:
   - SELECT * FROM dbo.SplitStringToWords 
         ('This, (I think), might be working')
   - SELECT * FROM dbo.SplitStringToWords('This, 
        must -I assume - deal with <brackets> ')
Returns: >
  a table of the words and their order in the text.
**/
RETURNS @Words TABLE ([TheOrder] INT IDENTITY, TheWord NVARCHAR(50) NOT NULL)
AS
  BEGIN
    DECLARE @StartWildcard VARCHAR(80), @EndWildcard VARCHAR(80), @Max INT,
      @start INT, @end INT, @Searched INT, @ii INT;
    SELECT @TheString=@TheString+' !',
		   @StartWildcard = '%[^'+Char(1)+'-'+Char(64)+'\-`<>{}|~]%', 
	       @EndWildcard = '%['+Char(1)+'-'+Char(64)+'\-`<>{}|~]%', 
           @Max = Len (@TheString), @Searched = 0, 
		   @end = -1, @Start = -2, @ii = 1
	  WHILE (@end <> 0 AND @start<>0 AND @end<>@start AND @ii<1000)
      BEGIN
        SELECT @start =
        PatIndex (@StartWildcard, Right(@TheString, @Max - @Searched) 
		  COLLATE Latin1_General_CI_AI )
        SELECT @end =
        @start
        + PatIndex (
                   @EndWildcard, Right(@TheString, @Max - @Searched - @start) 
				     COLLATE Latin1_General_CI_AI
                   );
        IF @end > 0 AND @start > 0 AND @end<>@start
          BEGIN
-- SQL Prompt formatting off
		  INSERT INTO @Words(TheWord) 
		    SELECT Substring(@THeString,@searched+@Start,@end-@start)
			-- to force an error try commenting out the line above
			-- and uncommenting this next line below
			--SELECT Substring(@THeString,@searched+@Start+1,@end-@start)
			--to make the tests fail
		  END
-- SQL Prompt formatting on
        SELECT @Searched = @Searched + @end, @ii = @ii + 1;
      END;
    RETURN;
  END;
GO
/****** Object:  Table [dbo].[TagTitle]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagTitle](
	[TagTitle_ID] [int] IDENTITY(1,1) NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
	[Is_Primary] [bit] NOT NULL,
	[TagName_ID] [int] NOT NULL,
 CONSTRAINT [PK_TagNameTitle] PRIMARY KEY CLUSTERED 
(
	[title_id] ASC,
	[TagName_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[publications]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[publications](
	[Publication_id] [dbo].[tid] NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[pub_id] [char](8) NULL,
	[notes] [nvarchar](4000) NULL,
	[pubdate] [datetime] NOT NULL,
 CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED 
(
	[Publication_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[editions]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[editions](
	[Edition_id] [int] IDENTITY(1,1) NOT NULL,
	[publication_id] [dbo].[tid] NOT NULL,
	[Publication_type] [nvarchar](20) NOT NULL,
	[EditionDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_editions] PRIMARY KEY CLUSTERED 
(
	[Edition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prices]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prices](
	[Price_id] [int] IDENTITY(1,1) NOT NULL,
	[Edition_id] [int] NULL,
	[price] [dbo].[Dollars] NULL,
	[advance] [dbo].[Dollars] NULL,
	[royalty] [int] NULL,
	[ytd_sales] [int] NULL,
	[PriceStartDate] [datetime2](7) NOT NULL,
	[PriceEndDate] [datetime2](7) NULL,
 CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED 
(
	[Price_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagName]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagName](
	[TagName_ID] [int] IDENTITY(1,1) NOT NULL,
	[Tag] [nvarchar](80) NOT NULL,
 CONSTRAINT [TagnameSurrogate] PRIMARY KEY CLUSTERED 
(
	[TagName_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Uniquetag] UNIQUE NONCLUSTERED 
(
	[Tag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[titles]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[titles]
/* this view replaces the old TITLES table and shows only those books that represent each publication and only the current price */
AS
SELECT publications.Publication_id AS title_id, publications.title,
  Tag AS [Type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate
  FROM publications
    INNER JOIN editions
      ON editions.publication_id = publications.Publication_id
     AND Publication_type = 'book'
    INNER JOIN prices
      ON prices.Edition_id = editions.Edition_id
    LEFT OUTER JOIN TagTitle
      ON TagTitle.title_id = publications.Publication_id
     AND TagTitle.Is_Primary = 1 --just the first, primary, tag
    LEFT OUTER JOIN dbo.TagName
      ON TagTitle.TagName_ID = TagName.TagName_ID
  WHERE prices.PriceEndDate IS NULL;
GO
/****** Object:  Table [dbo].[publishers]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[publishers](
	[pub_id] [char](8) NOT NULL,
	[pub_name] [nvarchar](100) NULL,
	[city] [nvarchar](100) NULL,
	[state] [char](2) NULL,
	[country] [nvarchar](80) NULL,
 CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED 
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PublishersByPublicationType]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PublishersByPublicationType] as
/* A view to provide the number of each type of publication produced
by each publisher*/
SELECT Coalesce(publishers.pub_name, '---All types') AS publisher,
Sum(CASE WHEN Editions.Publication_type = 'AudioBook' THEN 1 ELSE 0 END) AS 'AudioBook',
Sum(CASE WHEN Editions.Publication_type ='Book' THEN 1 ELSE 0 END) AS 'Book',
Sum(CASE WHEN Editions.Publication_type ='Calendar' THEN 1 ELSE 0 END) AS 'Calendar',
Sum(CASE WHEN Editions.Publication_type ='Ebook' THEN 1 ELSE 0 END) AS 'Ebook',
Sum(CASE WHEN Editions.Publication_type ='Hardback' THEN 1 ELSE 0 END) AS 'Hardback',
Sum(CASE WHEN Editions.Publication_type ='Map' THEN 1 ELSE 0 END) AS 'Map',
Sum(CASE WHEN Editions.Publication_type ='Paperback' THEN 1 ELSE 0 END) AS 'PaperBack',
Count(*) AS total
 FROM dbo.publishers
INNER JOIN dbo.publications
ON publications.pub_id = publishers.pub_id
INNER JOIN editions ON editions.publication_id = publications.Publication_id
INNER JOIN dbo.prices ON prices.Edition_id = editions.Edition_id
WHERE prices.PriceEndDate IS null 
GROUP BY publishers.pub_name
WITH ROLLUP
GO
/****** Object:  View [dbo].[TitlesAndEditionsByPublisher]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TitlesAndEditionsByPublisher] (Publisher,Title,ListofEditions)
AS
/* A view to provide the number of each type of publication produced
Select * from [dbo].[TitlesAndEditionsByPublisher]
by each publisher*/

SELECT publishers.pub_name AS publisher, publications.title,
  Stuff(
         (
         SELECT ', ' + editions.Publication_type + ' ($' + Convert(VARCHAR(20), prices.price)
                + ')'
           FROM editions
             INNER JOIN dbo.prices 
               ON prices.Edition_id = editions.Edition_id
           WHERE prices.PriceEndDate IS NULL
             AND editions.publication_id = publications.Publication_id
         FOR XML PATH(''), TYPE
         ).value('.', 'nvarchar(max)'),
         1,
         2,
         ''
       ) AS ListOfEditions
  FROM dbo.publishers
    INNER JOIN dbo.publications
      ON publications.pub_id = publishers.pub_id;
GO
/****** Object:  Table [dbo].[authors]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[authors](
	[au_id] [dbo].[id] NOT NULL,
	[au_lname] [nvarchar](80) NOT NULL,
	[au_fname] [nvarchar](80) NOT NULL,
	[phone] [nvarchar](40) NOT NULL,
	[address] [nvarchar](80) NULL,
	[city] [nvarchar](40) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	[contract] [bit] NOT NULL,
 CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[titleauthor]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titleauthor](
	[au_id] [dbo].[id] NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
	[au_ord] [tinyint] NULL,
	[royaltyper] [int] NULL,
 CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC,
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[titleview]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[titleview]
AS
SELECT title, au_ord, au_lname, price, ytd_sales, pub_id
  FROM authors, titles, titleauthor
  WHERE authors.au_id = titleauthor.au_id
    AND titles.title_id = titleauthor.title_id;
GO
/****** Object:  Table [people].[Organisation]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Organisation](
	[organisation_ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganisationName] [nvarchar](100) NOT NULL,
	[LineOfBusiness] [nvarchar](100) NOT NULL,
	[LegacyIdentifier] [nvarchar](30) NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [organisationIDPK] PRIMARY KEY CLUSTERED 
(
	[organisation_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[Address]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Address](
	[Address_ID] [int] IDENTITY(1,1) NOT NULL,
	[AddressLine1] [people].[PersonalAddressline] NULL,
	[AddressLine2] [people].[PersonalAddressline] NULL,
	[City] [people].[PersonalLocation] NULL,
	[Region] [people].[PersonalLocation] NULL,
	[PostalCode] [people].[PersonalPostalCode] NULL,
	[country] [nvarchar](50) NULL,
	[Full_Address]  AS (stuff((((coalesce(', '+[AddressLine1],'')+coalesce(', '+[AddressLine2],''))+coalesce(', '+[City],''))+coalesce(', '+[Region],''))+coalesce(', '+[PostalCode],''),(1),(2),'')),
	[LegacyIdentifier] [nvarchar](30) NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [AddressPK] PRIMARY KEY CLUSTERED 
(
	[Address_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[Location]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Location](
	[Location_ID] [int] IDENTITY(1,1) NOT NULL,
	[organisation_id] [int] NOT NULL,
	[Address_id] [int] NOT NULL,
	[TypeOfAddress] [nvarchar](40) NOT NULL,
	[Start_date] [datetime] NOT NULL,
	[End_date] [datetime] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [LocationPK] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [people].[publishers]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [people].[publishers]
as
SELECT Replace (Address.LegacyIdentifier, 'pub-', '') AS pub_id,
  OrganisationName AS pub_name, City, Region AS state, country
  FROM People.Organisation
    INNER JOIN People.Location
      ON Location.organisation_id = Organisation.organisation_ID
    INNER JOIN People.Address
      ON Address.Address_ID = Location.Address_id
  WHERE LineOfBusiness = 'Publisher' AND End_date IS NULL;
GO
/****** Object:  Table [people].[Person]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Person](
	[person_ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [people].[PersonalTitle] NULL,
	[Nickname] [people].[PersonalName] NULL,
	[FirstName] [people].[PersonalName] NOT NULL,
	[MiddleName] [people].[PersonalName] NULL,
	[LastName] [people].[PersonalName] NOT NULL,
	[Suffix] [people].[PersonalSuffix] NULL,
	[fullName]  AS (((((coalesce([Title]+' ','')+[FirstName])+coalesce(' '+[MiddleName],''))+' ')+[LastName])+coalesce(' '+[Suffix],'')),
	[LegacyIdentifier] [nvarchar](30) NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PersonIDPK] PRIMARY KEY CLUSTERED 
(
	[person_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[Abode]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Abode](
	[Abode_ID] [int] IDENTITY(1,1) NOT NULL,
	[Person_id] [int] NOT NULL,
	[Address_id] [int] NOT NULL,
	[TypeOfAddress] [nvarchar](40) NOT NULL,
	[Start_date] [datetime] NOT NULL,
	[End_date] [datetime] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [AbodePK] PRIMARY KEY CLUSTERED 
(
	[Abode_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[Phone]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Phone](
	[Phone_ID] [int] IDENTITY(1,1) NOT NULL,
	[Person_id] [int] NOT NULL,
	[TypeOfPhone] [nvarchar](40) NOT NULL,
	[DiallingNumber] [people].[PersonalPhoneNumber] NOT NULL,
	[Start_date] [datetime] NOT NULL,
	[End_date] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PhonePK] PRIMARY KEY CLUSTERED 
(
	[Phone_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [people].[authors]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [people].[authors]
AS
SELECT Replace (Address.LegacyIdentifier, 'au-', '') AS au_id,
  LastName AS au_lname, FirstName AS au_fname, DiallingNumber AS phone,
  Coalesce (AddressLine1, '') + Coalesce (' ' + AddressLine2, '') AS address,
  City, Region AS state, PostalCode AS zip
  FROM People.Person
    INNER JOIN People.Abode
      ON Abode.Person_id = Person.person_ID
    INNER JOIN People.Address
      ON Address.Address_ID = Abode.Address_id
    LEFT OUTER JOIN People.Phone
	 ON Phone.Person_id = Person.person_ID
  WHERE People.Abode.End_date IS NULL 
  AND phone.End_date IS null
  AND Person.LegacyIdentifier LIKE 'au-%';
GO
/****** Object:  Table [dbo].[discounts]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[discounts](
	[discounttype] [nvarchar](80) NOT NULL,
	[stor_id] [char](4) NULL,
	[lowqty] [smallint] NULL,
	[highqty] [smallint] NULL,
	[discount] [decimal](4, 2) NOT NULL,
	[Discount_id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Discount_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employee]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employee](
	[emp_id] [dbo].[empid] NOT NULL,
	[fname] [nvarchar](40) NOT NULL,
	[minit] [char](1) NULL,
	[lname] [nvarchar](60) NOT NULL,
	[job_id] [smallint] NOT NULL,
	[job_lvl] [tinyint] NULL,
	[pub_id] [char](8) NOT NULL,
	[hire_date] [datetime] NOT NULL,
 CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [employee_ind]    Script Date: 20/09/2021 10:11:16 ******/
CREATE CLUSTERED INDEX [employee_ind] ON [dbo].[employee]
(
	[lname] ASC,
	[fname] ASC,
	[minit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[jobs](
	[job_id] [smallint] IDENTITY(1,1) NOT NULL,
	[job_desc] [varchar](50) NOT NULL,
	[min_lvl] [tinyint] NOT NULL,
	[max_lvl] [tinyint] NOT NULL,
 CONSTRAINT [PK__jobs__6E32B6A51A14E395] PRIMARY KEY CLUSTERED 
(
	[job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pub_info]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pub_info](
	[pub_id] [char](8) NOT NULL,
	[logo] [varbinary](max) NULL,
	[pr_info] [nvarchar](max) NULL,
 CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED 
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roysched]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roysched](
	[title_id] [dbo].[tid] NOT NULL,
	[lorange] [int] NULL,
	[hirange] [int] NULL,
	[royalty] [int] NULL,
	[roysched_id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[roysched_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sales]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sales](
	[stor_id] [char](4) NOT NULL,
	[ord_num] [nvarchar](40) NOT NULL,
	[ord_date] [datetime] NOT NULL,
	[qty] [smallint] NOT NULL,
	[payterms] [nvarchar](40) NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
 CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED 
(
	[stor_id] ASC,
	[ord_num] ASC,
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stores]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stores](
	[stor_id] [char](4) NOT NULL,
	[stor_name] [nvarchar](80) NULL,
	[stor_address] [nvarchar](80) NULL,
	[city] [nvarchar](40) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
 CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED 
(
	[stor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[AddressType]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[AddressType](
	[TypeOfAddress] [nvarchar](40) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [TypeOfAddressPK] PRIMARY KEY CLUSTERED 
(
	[TypeOfAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[CreditCard]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[CreditCard](
	[CreditCardID] [int] IDENTITY(1,1) NOT NULL,
	[Person_id] [int] NOT NULL,
	[CardNumber] [people].[PersonalPaymentCardNumber] NOT NULL,
	[ValidFrom] [date] NOT NULL,
	[ValidTo] [date] NOT NULL,
	[CVC] [people].[PersonalCVC] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [CreditCardPK] PRIMARY KEY CLUSTERED 
(
	[CreditCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [CreditCardWasntUnique] UNIQUE NONCLUSTERED 
(
	[CardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [DuplicateCreditCardUK] UNIQUE NONCLUSTERED 
(
	[Person_id] ASC,
	[CardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[EmailAddress]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[EmailAddress](
	[EmailID] [int] IDENTITY(1,1) NOT NULL,
	[Person_id] [int] NOT NULL,
	[EmailAddress] [people].[PersonalEmailAddress] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [EmailPK] PRIMARY KEY CLUSTERED 
(
	[EmailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[Note]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[Note](
	[Note_id] [int] IDENTITY(1,1) NOT NULL,
	[Note] [people].[PersonalNote] NOT NULL,
	[NoteStart]  AS (coalesce(left([Note],(850)),'Blank'+CONVERT([nvarchar](20),rand()*(20)))),
	[InsertionDate] [datetime] NOT NULL,
	[InsertedBy] [sysname] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [NotePK] PRIMARY KEY CLUSTERED 
(
	[Note_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [people].[NotePerson]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[NotePerson](
	[NotePerson_id] [int] IDENTITY(1,1) NOT NULL,
	[Person_id] [int] NOT NULL,
	[Note_id] [int] NOT NULL,
	[InsertionDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [NotePersonPK] PRIMARY KEY CLUSTERED 
(
	[NotePerson_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [DuplicateUK] UNIQUE NONCLUSTERED 
(
	[Person_id] ASC,
	[Note_id] ASC,
	[InsertionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [people].[PhoneType]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [people].[PhoneType](
	[TypeOfPhone] [nvarchar](40) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PhoneTypePK] PRIMARY KEY CLUSTERED 
(
	[TypeOfPhone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [aunmind]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors]
(
	[au_lname] ASC,
	[au_fname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Storid_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [Storid_index] ON [dbo].[discounts]
(
	[stor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Publicationid_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [Publicationid_index] ON [dbo].[editions]
(
	[publication_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [JobID_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [JobID_index] ON [dbo].[employee]
(
	[job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [pub_id_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [pub_id_index] ON [dbo].[employee]
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [editionid_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [editionid_index] ON [dbo].[prices]
(
	[Edition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [pubid_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [pubid_index] ON [dbo].[publications]
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [TagName_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [TagName_index] ON [dbo].[TagTitle]
(
	[TagName_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Titleid_index]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [Titleid_index] ON [dbo].[TagTitle]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auidind]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor]
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [SearchByOrganisationName]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [SearchByOrganisationName] ON [people].[Organisation]
(
	[OrganisationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [SearchByPersonLastname]    Script Date: 20/09/2021 10:11:16 ******/
CREATE NONCLUSTERED INDEX [SearchByPersonLastname] ON [people].[Person]
(
	[LastName] ASC,
	[FirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[authors] ADD  CONSTRAINT [AssumeUnknown]  DEFAULT ('UNKNOWN') FOR [phone]
GO
ALTER TABLE [dbo].[editions] ADD  DEFAULT ('book') FOR [Publication_type]
GO
ALTER TABLE [dbo].[editions] ADD  DEFAULT (getdate()) FOR [EditionDate]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [AssumeJobIDof1]  DEFAULT ((1)) FOR [job_id]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [AssumeJobLevelof10]  DEFAULT ((10)) FOR [job_lvl]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [AssumeAPub_IDof9952]  DEFAULT ('9952') FOR [pub_id]
GO
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [AssumeAewHire]  DEFAULT (getdate()) FOR [hire_date]
GO
ALTER TABLE [dbo].[jobs] ADD  CONSTRAINT [AssumeANewPosition]  DEFAULT ('New Position - title not formalized yet') FOR [job_desc]
GO
ALTER TABLE [dbo].[prices] ADD  DEFAULT (getdate()) FOR [PriceStartDate]
GO
ALTER TABLE [dbo].[publications] ADD  CONSTRAINT [pub_NowDefault]  DEFAULT (getdate()) FOR [pubdate]
GO
ALTER TABLE [dbo].[publishers] ADD  CONSTRAINT [AssumeItsTheSatates]  DEFAULT ('USA') FOR [country]
GO
ALTER TABLE [dbo].[TagTitle] ADD  CONSTRAINT [NotPrimary]  DEFAULT ((0)) FOR [Is_Primary]
GO
ALTER TABLE [people].[Abode] ADD  CONSTRAINT [AbodeModifiedD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[Address] ADD  CONSTRAINT [AddressModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[AddressType] ADD  CONSTRAINT [AddressTypeModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[CreditCard] ADD  CONSTRAINT [CreditCardModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[EmailAddress] ADD  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [people].[EmailAddress] ADD  CONSTRAINT [EmailAddressModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[Location] ADD  CONSTRAINT [LocationModifiedD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[Note] ADD  CONSTRAINT [NoteInsertionDateDL]  DEFAULT (getdate()) FOR [InsertionDate]
GO
ALTER TABLE [people].[Note] ADD  CONSTRAINT [GetUserName]  DEFAULT (user_name()) FOR [InsertedBy]
GO
ALTER TABLE [people].[Note] ADD  CONSTRAINT [NoteModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[NotePerson] ADD  CONSTRAINT [NotePersonInsertionDateD]  DEFAULT (getdate()) FOR [InsertionDate]
GO
ALTER TABLE [people].[NotePerson] ADD  CONSTRAINT [NotePersonModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[Organisation] ADD  CONSTRAINT [organisationModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[Person] ADD  CONSTRAINT [PersonModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[Phone] ADD  CONSTRAINT [PhoneModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [people].[PhoneType] ADD  CONSTRAINT [PhoneTypeModifiedDateD]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[discounts]  WITH CHECK ADD  CONSTRAINT [FK__discounts__store] FOREIGN KEY([stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[discounts] CHECK CONSTRAINT [FK__discounts__store]
GO
ALTER TABLE [dbo].[editions]  WITH CHECK ADD  CONSTRAINT [fk_edition] FOREIGN KEY([publication_id])
REFERENCES [dbo].[publications] ([Publication_id])
GO
ALTER TABLE [dbo].[editions] CHECK CONSTRAINT [fk_edition]
GO
ALTER TABLE [dbo].[employee]  WITH CHECK ADD  CONSTRAINT [FK__employee__job_id] FOREIGN KEY([job_id])
REFERENCES [dbo].[jobs] ([job_id])
GO
ALTER TABLE [dbo].[employee] CHECK CONSTRAINT [FK__employee__job_id]
GO
ALTER TABLE [dbo].[employee]  WITH CHECK ADD  CONSTRAINT [FK__employee__pub_id] FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[employee] CHECK CONSTRAINT [FK__employee__pub_id]
GO
ALTER TABLE [dbo].[prices]  WITH CHECK ADD  CONSTRAINT [fk_prices] FOREIGN KEY([Edition_id])
REFERENCES [dbo].[editions] ([Edition_id])
GO
ALTER TABLE [dbo].[prices] CHECK CONSTRAINT [fk_prices]
GO
ALTER TABLE [dbo].[pub_info]  WITH CHECK ADD  CONSTRAINT [FK__pub_info__pub_id] FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[pub_info] CHECK CONSTRAINT [FK__pub_info__pub_id]
GO
ALTER TABLE [dbo].[publications]  WITH CHECK ADD  CONSTRAINT [fkPublishers] FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[publications] CHECK CONSTRAINT [fkPublishers]
GO
ALTER TABLE [dbo].[roysched]  WITH CHECK ADD  CONSTRAINT [FK__roysched__title] FOREIGN KEY([title_id])
REFERENCES [dbo].[publications] ([Publication_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[roysched] CHECK CONSTRAINT [FK__roysched__title]
GO
ALTER TABLE [dbo].[sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Stores] FOREIGN KEY([stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales] CHECK CONSTRAINT [FK_Sales_Stores]
GO
ALTER TABLE [dbo].[sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Title] FOREIGN KEY([title_id])
REFERENCES [dbo].[publications] ([Publication_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sales] CHECK CONSTRAINT [FK_Sales_Title]
GO
ALTER TABLE [dbo].[TagTitle]  WITH CHECK ADD  CONSTRAINT [fkTagname] FOREIGN KEY([TagName_ID])
REFERENCES [dbo].[TagName] ([TagName_ID])
GO
ALTER TABLE [dbo].[TagTitle] CHECK CONSTRAINT [fkTagname]
GO
ALTER TABLE [dbo].[TagTitle]  WITH CHECK ADD  CONSTRAINT [FKTitle_id] FOREIGN KEY([title_id])
REFERENCES [dbo].[publications] ([Publication_id])
GO
ALTER TABLE [dbo].[TagTitle] CHECK CONSTRAINT [FKTitle_id]
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD  CONSTRAINT [FK__titleauth__au_id] FOREIGN KEY([au_id])
REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor] CHECK CONSTRAINT [FK__titleauth__au_id]
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD  CONSTRAINT [FK__titleauth__title] FOREIGN KEY([title_id])
REFERENCES [dbo].[publications] ([Publication_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[titleauthor] CHECK CONSTRAINT [FK__titleauth__title]
GO
ALTER TABLE [people].[Abode]  WITH CHECK ADD  CONSTRAINT [Abode_AddressFK] FOREIGN KEY([Address_id])
REFERENCES [people].[Address] ([Address_ID])
GO
ALTER TABLE [people].[Abode] CHECK CONSTRAINT [Abode_AddressFK]
GO
ALTER TABLE [people].[Abode]  WITH CHECK ADD  CONSTRAINT [Abode_AddressTypeFK] FOREIGN KEY([TypeOfAddress])
REFERENCES [people].[AddressType] ([TypeOfAddress])
GO
ALTER TABLE [people].[Abode] CHECK CONSTRAINT [Abode_AddressTypeFK]
GO
ALTER TABLE [people].[Abode]  WITH CHECK ADD  CONSTRAINT [Abode_PersonFK] FOREIGN KEY([Person_id])
REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[Abode] CHECK CONSTRAINT [Abode_PersonFK]
GO
ALTER TABLE [people].[CreditCard]  WITH CHECK ADD  CONSTRAINT [CreditCard_PersonFK] FOREIGN KEY([Person_id])
REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[CreditCard] CHECK CONSTRAINT [CreditCard_PersonFK]
GO
ALTER TABLE [people].[EmailAddress]  WITH CHECK ADD  CONSTRAINT [EmailAddress_PersonFK] FOREIGN KEY([Person_id])
REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[EmailAddress] CHECK CONSTRAINT [EmailAddress_PersonFK]
GO
ALTER TABLE [people].[Location]  WITH CHECK ADD  CONSTRAINT [Location_AddressFK] FOREIGN KEY([Address_id])
REFERENCES [people].[Address] ([Address_ID])
GO
ALTER TABLE [people].[Location] CHECK CONSTRAINT [Location_AddressFK]
GO
ALTER TABLE [people].[Location]  WITH CHECK ADD  CONSTRAINT [Location_AddressTypeFK] FOREIGN KEY([TypeOfAddress])
REFERENCES [people].[AddressType] ([TypeOfAddress])
GO
ALTER TABLE [people].[Location] CHECK CONSTRAINT [Location_AddressTypeFK]
GO
ALTER TABLE [people].[Location]  WITH CHECK ADD  CONSTRAINT [Location_organisationFK] FOREIGN KEY([organisation_id])
REFERENCES [people].[Organisation] ([organisation_ID])
GO
ALTER TABLE [people].[Location] CHECK CONSTRAINT [Location_organisationFK]
GO
ALTER TABLE [people].[NotePerson]  WITH CHECK ADD  CONSTRAINT [NotePerson_NoteFK] FOREIGN KEY([Note_id])
REFERENCES [people].[Note] ([Note_id])
GO
ALTER TABLE [people].[NotePerson] CHECK CONSTRAINT [NotePerson_NoteFK]
GO
ALTER TABLE [people].[NotePerson]  WITH CHECK ADD  CONSTRAINT [NotePerson_PersonFK] FOREIGN KEY([Person_id])
REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[NotePerson] CHECK CONSTRAINT [NotePerson_PersonFK]
GO
ALTER TABLE [people].[Phone]  WITH CHECK ADD FOREIGN KEY([TypeOfPhone])
REFERENCES [people].[PhoneType] ([TypeOfPhone])
GO
ALTER TABLE [people].[Phone]  WITH CHECK ADD  CONSTRAINT [Phone_PersonFK] FOREIGN KEY([Person_id])
REFERENCES [people].[Person] ([person_ID])
GO
ALTER TABLE [people].[Phone] CHECK CONSTRAINT [Phone_PersonFK]
GO
ALTER TABLE [dbo].[authors]  WITH CHECK ADD  CONSTRAINT [CK__authors__au_id] CHECK  (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] CHECK CONSTRAINT [CK__authors__au_id]
GO
ALTER TABLE [dbo].[authors]  WITH CHECK ADD  CONSTRAINT [CK__authors__zip] CHECK  (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] CHECK CONSTRAINT [CK__authors__zip]
GO
ALTER TABLE [dbo].[employee]  WITH CHECK ADD  CONSTRAINT [CK_emp_id] CHECK  (([emp_id] like '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR [emp_id] like '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'))
GO
ALTER TABLE [dbo].[employee] CHECK CONSTRAINT [CK_emp_id]
GO
ALTER TABLE [dbo].[jobs]  WITH CHECK ADD  CONSTRAINT [CK__jobs__max_lvl] CHECK  (([max_lvl]<=(250)))
GO
ALTER TABLE [dbo].[jobs] CHECK CONSTRAINT [CK__jobs__max_lvl]
GO
ALTER TABLE [dbo].[jobs]  WITH CHECK ADD  CONSTRAINT [CK__jobs__min_lvl] CHECK  (([min_lvl]>=(10)))
GO
ALTER TABLE [dbo].[jobs] CHECK CONSTRAINT [CK__jobs__min_lvl]
GO
ALTER TABLE [dbo].[publishers]  WITH CHECK ADD  CONSTRAINT [CK__publisher__pub_id] CHECK  (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
ALTER TABLE [dbo].[publishers] CHECK CONSTRAINT [CK__publisher__pub_id]
GO
ALTER TABLE [people].[Address]  WITH CHECK ADD  CONSTRAINT [Address_Not_Complete] CHECK  ((coalesce([AddressLine1],[AddressLine2],[City],[PostalCode]) IS NOT NULL))
GO
ALTER TABLE [people].[Address] CHECK CONSTRAINT [Address_Not_Complete]
GO
/****** Object:  StoredProcedure [dbo].[byroyalty]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[byroyalty] @percentage INT
AS
  BEGIN
    SELECT titleauthor.au_id
      FROM dbo.titleauthor AS titleauthor
      WHERE titleauthor.royaltyper = @percentage;
  END;
GO
/****** Object:  StoredProcedure [dbo].[reptq1]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reptq1]
AS
  BEGIN
    SELECT CASE WHEN Grouping(publications.pub_id) = 1 
	         THEN 'ALL' ELSE publications.pub_id END AS pub_id,
      Avg(price) AS avg_price
      FROM dbo.publishers
        INNER JOIN dbo.publications
          ON publications.pub_id = publishers.pub_id
        INNER JOIN editions
          ON editions.publication_id = publications.Publication_id
        INNER JOIN dbo.prices
          ON prices.Edition_id = editions.Edition_id
      WHERE prices.PriceEndDate IS NULL
      GROUP BY publications.pub_id WITH ROLLUP
      ORDER BY publications.pub_id;
  END;
GO
/****** Object:  StoredProcedure [dbo].[reptq2]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reptq2]
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
/****** Object:  StoredProcedure [dbo].[reptq3]    Script Date: 20/09/2021 10:11:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reptq3] @lolimit dbo.Dollars, @hilimit dbo.Dollars,
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The key to the Authors Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'au_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last name of the author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'au_lname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'first name of the author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'au_fname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the author''s phone number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'phone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the author=s firest line address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the city where the author lives' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'city'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the state where the author lives' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'state'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the zip of the address where the author lives' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'zip'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'had the author agreed a contract?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'contract'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The authors of the publications. a publication can have one or more author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of discount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts', @level2type=N'COLUMN',@level2name=N'discounttype'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The store that has the discount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts', @level2type=N'COLUMN',@level2name=N'stor_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The lowest order quantity for which the discount applies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts', @level2type=N'COLUMN',@level2name=N'lowqty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The highest order quantity for which the discount applies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts', @level2type=N'COLUMN',@level2name=N'highqty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the percentage discount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts', @level2type=N'COLUMN',@level2name=N'discount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Discounts Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts', @level2type=N'COLUMN',@level2name=N'Discount_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'These are the discounts offered by the sales people for bulk orders' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'discounts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Editions Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'editions', @level2type=N'COLUMN',@level2name=N'Edition_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the foreign key to the publication' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'editions', @level2type=N'COLUMN',@level2name=N'publication_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the type of publication' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'editions', @level2type=N'COLUMN',@level2name=N'Publication_type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the date at which this edition was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'editions', @level2type=N'COLUMN',@level2name=N'EditionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A publication can come out in several different editions, of maybe a different type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'editions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The key to the Employee Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'emp_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'first name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'fname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'middle initial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'minit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'lname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the job that the employee does' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'job_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the job level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'job_lvl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the publisher that the employee works for' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'pub_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the date that the employeee was hired' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee', @level2type=N'COLUMN',@level2name=N'hire_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An employee of any of the publishers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'employee'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Jobs Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jobs', @level2type=N'COLUMN',@level2name=N'job_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description of the job' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jobs', @level2type=N'COLUMN',@level2name=N'job_desc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the minimum pay level appropriate for the job' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jobs', @level2type=N'COLUMN',@level2name=N'min_lvl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the maximum pay level appropriate for the job' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jobs', @level2type=N'COLUMN',@level2name=N'max_lvl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'These are the job descriptions and min/max salary level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jobs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Prices Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'Price_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The edition that this price applies to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'Edition_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the price in dollars' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the advance to the authors' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'advance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the royalty' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'royalty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the current sales this year' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'ytd_sales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the start date for which this price applies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'PriceStartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'null if the price is current, otherwise the date at which it was supoerceded' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices', @level2type=N'COLUMN',@level2name=N'PriceEndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'these are the current prices of every edition of every publication' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'prices'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The foreign key to the publisher' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pub_info', @level2type=N'COLUMN',@level2name=N'pub_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the publisher''s logo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pub_info', @level2type=N'COLUMN',@level2name=N'logo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The blurb of this publisher' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pub_info', @level2type=N'COLUMN',@level2name=N'pr_info'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'this holds the special information about every publisher' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'pub_info'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Publications Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publications', @level2type=N'COLUMN',@level2name=N'Publication_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the title of the publicxation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publications', @level2type=N'COLUMN',@level2name=N'title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the legacy publication key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publications', @level2type=N'COLUMN',@level2name=N'pub_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'any notes about this publication' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publications', @level2type=N'COLUMN',@level2name=N'notes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the date that it was published' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publications', @level2type=N'COLUMN',@level2name=N'pubdate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This lists every publication marketed by the distributor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publications'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Publishers Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publishers', @level2type=N'COLUMN',@level2name=N'pub_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the publisher' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publishers', @level2type=N'COLUMN',@level2name=N'pub_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the city where this publisher is based' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publishers', @level2type=N'COLUMN',@level2name=N'city'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Thge state where this publisher is based' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publishers', @level2type=N'COLUMN',@level2name=N'state'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The country where this publisher is based' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publishers', @level2type=N'COLUMN',@level2name=N'country'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'this is a table of publishers who we distribute books for' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'publishers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The title to which this applies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'roysched', @level2type=N'COLUMN',@level2name=N'title_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the lowest range to which the royalty applies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'roysched', @level2type=N'COLUMN',@level2name=N'lorange'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the highest range to which this royalty applies' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'roysched', @level2type=N'COLUMN',@level2name=N'hirange'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the royalty' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'roysched', @level2type=N'COLUMN',@level2name=N'royalty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the RoySched Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'roysched', @level2type=N'COLUMN',@level2name=N'roysched_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'this is a table of the authors royalty schedule' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'roysched'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The store for which the sales apply' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'stor_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the reference to the order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'ord_num'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the date of the order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'ord_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the quantity ordered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'qty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the pay terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'payterms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'foreign key to the title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'title_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'these are the sales of every edition of every publication' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The primary key to the Store Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores', @level2type=N'COLUMN',@level2name=N'stor_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the store' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores', @level2type=N'COLUMN',@level2name=N'stor_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The first-line address of the store' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores', @level2type=N'COLUMN',@level2name=N'stor_address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The city in which the store is based' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores', @level2type=N'COLUMN',@level2name=N'city'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The state where the store is base' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores', @level2type=N'COLUMN',@level2name=N'state'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The zipt code for the store' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores', @level2type=N'COLUMN',@level2name=N'zip'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'these are all the stores who are our customers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'stores'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the Tag Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagName', @level2type=N'COLUMN',@level2name=N'TagName_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the name of the tag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagName', @level2type=N'COLUMN',@level2name=N'Tag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'All the categories of publications' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The surrogate key to the TagTitle Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagTitle', @level2type=N'COLUMN',@level2name=N'TagTitle_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The foreign key to the title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagTitle', @level2type=N'COLUMN',@level2name=N'title_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is this the primary tag (e.g. ''Fiction'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagTitle', @level2type=N'COLUMN',@level2name=N'Is_Primary'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The foreign key to the tagname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagTitle', @level2type=N'COLUMN',@level2name=N'TagName_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This relates tags to publications so that publications can have more than one' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TagTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to the author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'titleauthor', @level2type=N'COLUMN',@level2name=N'au_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key to the publication' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'titleauthor', @level2type=N'COLUMN',@level2name=N'title_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' the order in which authors are listed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'titleauthor', @level2type=N'COLUMN',@level2name=N'au_ord'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'the royalty percentage figure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'titleauthor', @level2type=N'COLUMN',@level2name=N'royaltyper'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'this is a table that relates authors to publications, and gives their order of listing and royalty' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'titleauthor'

