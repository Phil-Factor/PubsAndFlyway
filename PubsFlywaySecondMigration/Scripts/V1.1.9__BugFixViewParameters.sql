Alter VIEW dbo.TitlesAndEditionsByPublisher (Publisher,Title,ListofEditions)
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
