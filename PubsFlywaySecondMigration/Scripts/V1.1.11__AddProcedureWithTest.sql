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
/* So now we give the assertion tests */
IF EXISTS(
  SELECT * FROM dbo.SplitStringToWords ('This, (I think), might be working')
   EXCEPT 
   SELECT * FROM 
    OpenJson('[{"o":1,"w":"This"},{"o":2,"w":"I"},{"o":3,"w":"think"},
              {"o":4,"w":"might"},{"o":5,"w":"be"},{"o":6,"w":"working"}]')
    WITH ( TheOrder int '$.o', TheWord NVarchar(80) '$.w'))
	RAISERROR('The first assertion test failed',18,1);


IF EXISTS(
  SELECT * FROM dbo.SplitStringToWords ('Yan, Tan, Tether, Mether, Pip, Azer, Sezar') 
   EXCEPT 
   SELECT * FROM 
    OpenJson('[{"o":1,"w":"Yan"},{"o":2,"w":"Tan"},{"o":3,"w":"Tether"},{"o":4,"w":"Mether"},
	{"o":5,"w":"Pip"},{"o":6,"w":"Azer"},{"o":7,"w":"Sezar"}]')
    WITH ( TheOrder int '$.o', TheWord NVarchar(80) '$.w'))
	RAISERROR('The second assertion test failed',18,1);

IF EXISTS(
  SELECT * FROM dbo.SplitStringToWords ('This!!!




is 
a <very>
{cautious} test') 
   EXCEPT 
   SELECT * FROM 
    OpenJson('[{"o":1,"w":"This"},{"o":2,"w":"is"},{"o":3,"w":"a"},
	   {"o":4,"w":"very"},{"o":5,"w":"cautious"},{"o":6,"w":"test"}]')
    WITH ( TheOrder int '$.o', TheWord NVarchar(80) '$.w'))
	RAISERROR('The Third assertion test failed',18,1);
