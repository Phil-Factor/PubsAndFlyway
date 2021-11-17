PRINT 'You may not be able to see this'
/*Raiserror (N'this first message is sent as state 9,1',9,1);--sent as message
Raiserror (N'this second message is sent as state 10,2',10,2);--sent as message
Raiserror (N'this third message is sent as state 11,1',11,1);
Raiserror (N'this fourth message is sent as state 12,2',12,2);
Raiserror (N'this fifth message is sent as state 13,1',13,1);
Raiserror (N'this sixth message is sent as state 14,2',14,2);
Raiserror (N'this seventh message is sent as state 15,7',15,7);
Raiserror (N'this eighth message is sent as state 16,8',16,8);
Raiserror (N'this ninth message is sent as state 17,1',17,1);
Raiserror (N'this tenth message is sent as state 18,2',18,2);
Raiserror (N'this eleventh message is sent as state 18,3',18,3);
Raiserror (N'this twelveth message is sent as state 18,4',18,4);
Raiserror (N'this thirteenth message is sent as state 18,5',18,5);
Raiserror (N'this message is sent as state 18,6',18,6);
Raiserror (N'this message is sent as state 18,7',18,7);
Raiserror (N'this message is sent as state 18,8',18,8);
PRINT N'Creating [dbo].[SplitStringToWords] function'*/

go
CREATE FUNCTION [dbo].[SplitStringToWords] (@TheString NVARCHAR(MAX))
/**
Summary: >
  This table function takes a string of text and splits it into words. It
  takes the approach of identifying spaces between words so as to accomodate
  other character sets
Author: Phil Factor
Date: 27/05/2021
Revised: 28/10/2021
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
	       @EndWildcard   = '%[^1-9A-Z''-]%', 
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
PRINT N'ensuring that the [dbo].[SplitStringToWords] works'
/* So now we give the assertion tests */
Declare @Errors nvarchar(max)
IF EXISTS(
  SELECT * FROM dbo.SplitStringToWords ('This, (I think), might be working')
   EXCEPT 
   SELECT * FROM 
    OpenJson('[{"o":1,"w":"This"},{"o":2,"w":"I"},{"o":3,"w":"think"},
              {"o":4,"w":"might"},{"o":5,"w":"be"},{"o":6,"w":"working"}]')
    WITH ( TheOrder int '$.o', TheWord NVarchar(80) '$.w'))
	Select @Errors=Coalesce(@Errors+', ','The ')+'first'


IF EXISTS(
  SELECT * FROM dbo.SplitStringToWords ('Yan, Tan, Tether, Mether, Pip, Azer, Sezar') 
   EXCEPT 
   SELECT * FROM 
    OpenJson('[{"o":1,"w":"Yan"},{"o":2,"w":"Tan"},{"o":3,"w":"Tether"},{"o":4,"w":"Mether"},
	{"o":5,"w":"Pip"},{"o":6,"w":"Azer"},{"o":7,"w":"Sezar"}]')
    WITH ( TheOrder int '$.o', TheWord NVarchar(80) '$.w'))
	Select @Errors=Coalesce(@Errors+', ','The ')+'second'

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
	Select @Errors=Coalesce(@Errors+', ','The ')+'third'

if exists (
SELECT * from dbo.SplitStringToWords('  From the customer:   I''ve been totally-disgusted.  Appalling customer service for the online store.   
Although it looks good in the photos on the site, it looks cheap and poorly made.  You are utterly horrendous at customer service !!!!!!
Absolutely gutted, wouldn''t shop from you again.    Karl  replied:  Thanks for reaching out. I am so sorry, I definitely understand your 
concern and I''m escalating your issue so that someone can take a closer look at what''s going on right away. Please be assured that we 
take such complaints very seriously so I will take this up with the branch manager and his team to find out what went so wrong and ensure
the necessary steps, including refresher training, are put in place to prevent such a circumstance reoccurring in the future. 
In the meantime, I''d be most grateful of an opportunity to put this right for you. If you could contact me with your details via my 
e-mail address at the end of this note, I will get in touch to resolve the matter to your complete satisfaction.'
) except
Select * from openjson('[{"o":1,"w":"From"},{"o":2,"w":"the"},{"o":3,"w":"customer"},{"o":4,"w":"I''ve"}
 ,{"o":5,"w":"been"},{"o":6,"w":"totally-disgusted"},{"o":7,"w":"Appalling"},{"o":8,"w":"customer"},{"o":9,"w":"service"},
 {"o":10,"w":"for"},{"o":11,"w":"the"},{"o":12,"w":"online"},{"o":13,"w":"store"},{"o":14,"w":"Although"},{"o":15,"w":"it"},
 {"o":16,"w":"looks"},{"o":17,"w":"good"},{"o":18,"w":"in"},{"o":19,"w":"the"},{"o":20,"w":"photos"},{"o":21,"w":"on"},
 {"o":22,"w":"the"},{"o":23,"w":"site"},{"o":24,"w":"it"},{"o":25,"w":"looks"},{"o":26,"w":"cheap"},{"o":27,"w":"and"},
 {"o":28,"w":"poorly"},{"o":29,"w":"made"},{"o":30,"w":"You"},{"o":31,"w":"are"},{"o":32,"w":"utterly"},{"o":33,"w":"horrendous"}
 ,{"o":34,"w":"at"},{"o":35,"w":"customer"},{"o":36,"w":"service"},{"o":37,"w":"Absolutely"},{"o":38,"w":"gutted"},
 {"o":39,"w":"wouldn''t"},{"o":40,"w":"shop"},{"o":41,"w":"from"},{"o":42,"w":"you"},{"o":43,"w":"again"},{"o":44,"w":"Karl"},
 {"o":45,"w":"replied"},{"o":46,"w":"Thanks"},{"o":47,"w":"for"},{"o":48,"w":"reaching"},{"o":49,"w":"out"},{"o":50,"w":"I"},
 {"o":51,"w":"am"},{"o":52,"w":"so"},{"o":53,"w":"sorry"},{"o":54,"w":"I"},{"o":55,"w":"definitely"},{"o":56,"w":"understand"},
 {"o":57,"w":"your"},{"o":58,"w":"concern"},{"o":59,"w":"and"},{"o":60,"w":"I''m"},{"o":61,"w":"escalating"},{"o":62,"w":"your"},
 {"o":63,"w":"issue"},{"o":64,"w":"so"},{"o":65,"w":"that"},{"o":66,"w":"someone"},{"o":67,"w":"can"},{"o":68,"w":"take"},
 {"o":69,"w":"a"},{"o":70,"w":"closer"},{"o":71,"w":"look"},{"o":72,"w":"at"},{"o":73,"w":"what''s"},{"o":74,"w":"going"},{"o":75,"w":"on"},
 {"o":76,"w":"right"},{"o":77,"w":"away"},{"o":78,"w":"Please"},{"o":79,"w":"be"},{"o":80,"w":"assured"},{"o":81,"w":"that"},
 {"o":82,"w":"we"},{"o":83,"w":"take"},{"o":84,"w":"such"},{"o":85,"w":"complaints"},{"o":86,"w":"very"},{"o":87,"w":"seriously"},
 {"o":88,"w":"so"},{"o":89,"w":"I"},{"o":90,"w":"will"},{"o":91,"w":"take"},{"o":92,"w":"this"},{"o":93,"w":"up"},{"o":94,"w":"with"},
 {"o":95,"w":"the"},{"o":96,"w":"branch"},{"o":97,"w":"manager"},{"o":98,"w":"and"},{"o":99,"w":"his"},{"o":100,"w":"team"},
 {"o":101,"w":"to"},{"o":102,"w":"find"},{"o":103,"w":"out"},{"o":104,"w":"what"},{"o":105,"w":"went"},{"o":106,"w":"so"},
 {"o":107,"w":"wrong"},{"o":108,"w":"and"},{"o":109,"w":"ensure"},{"o":110,"w":"the"},{"o":111,"w":"necessary"},{"o":112,"w":"steps"},
 {"o":113,"w":"including"},{"o":114,"w":"refresher"},{"o":115,"w":"training"},{"o":116,"w":"are"},{"o":117,"w":"put"},{"o":118,"w":"in"},
 {"o":119,"w":"place"},{"o":120,"w":"to"},{"o":121,"w":"prevent"},{"o":122,"w":"such"},{"o":123,"w":"a"},{"o":124,"w":"circumstance"},
 {"o":125,"w":"reoccurring"},{"o":126,"w":"in"},{"o":127,"w":"the"},{"o":128,"w":"future"},{"o":129,"w":"In"},{"o":130,"w":"the"},
 {"o":131,"w":"meantime"},{"o":132,"w":"I''d"},{"o":133,"w":"be"},{"o":134,"w":"most"},{"o":135,"w":"grateful"},{"o":136,"w":"of"},
 {"o":137,"w":"an"},{"o":138,"w":"opportunity"},{"o":139,"w":"to"},{"o":140,"w":"put"},{"o":141,"w":"this"},{"o":142,"w":"right"},
 {"o":143,"w":"for"},{"o":144,"w":"you"},{"o":145,"w":"If"},{"o":146,"w":"you"},{"o":147,"w":"could"},{"o":148,"w":"contact"},
 {"o":149,"w":"me"},{"o":150,"w":"with"},{"o":151,"w":"your"},{"o":152,"w":"details"},{"o":153,"w":"via"},{"o":154,"w":"my"},{"o":155,"w":"e-mail"},
 {"o":156,"w":"address"},{"o":157,"w":"at"},{"o":158,"w":"the"},{"o":159,"w":"end"},{"o":160,"w":"of"},{"o":161,"w":"this"},
 {"o":162,"w":"note"},{"o":163,"w":"I"},{"o":164,"w":"will"},{"o":165,"w":"get"},{"o":166,"w":"in"},{"o":167,"w":"touch"},
 {"o":168,"w":"to"},{"o":169,"w":"resolve"},{"o":170,"w":"the"},{"o":171,"w":"matter"},{"o":172,"w":"to"},{"o":173,"w":"your"},
 {"o":174,"w":"complete"},{"o":175,"w":"satisfaction"}]')
    WITH ( TheOrder int '$.o', TheWord NVarchar(80) '$.w'))
	Select @Errors=Coalesce(@Errors+', ','The ')+'fourth'
PRINT N'Completed all four tests'
if @Errors is not null
	Begin
	Declare @message nVarchar(4000)=@errors+' unit test(s) for FUNCTION dbo.SplitStringToWords failed'
	Raiserror (@message,18,1);
	end
go	
print 'Creating  SentenceFrom function'
go
Create or alter function [dbo].[SentenceFrom] (
 @JsonData NVARCHAR(MAX), --the collection of objects, each one
 -- consisting of arrays of strings. If a word is prepended by  a 
 -- ^ character, it is the name of the object whose value is the array 
 -- of strings
 @Reference NVARCHAR(100), --the JSON reference to the object containing the
 -- list of strings to choose one item from.
 @level INT = 5--the depth of recursion allowed . 0 means don't recurse.
 ) 
/**
Summary: > 
   this function takes a json document that describes all the
   alternative components
   of a string and from it, it returns a string.
   basically, you give it a list of alternatives and it selects one of them. However
   if you put in the name of an array as one of the alternatives,rather than a word,
   it will, if it selects it, treat it as a new reference and will select one of 
   these alternatives.
Author: PhilFactor
Date: 05/11/2020
Database: PhilsScripts
Examples:
   - select dbo.SentenceFrom('{
     "name":[ "^prefix ^firstname ^lastname ^suffix",
	   "^prefix ^firstname ^lastname","^firstname ^lastname"
      ],
      "prefix":["Mr","Mrs","Miss","Sir","Dr","professor"
      ],
      "firstname":["Dick","Bob","Ravi","Jess","Karen"
      ],
      "lastname":["Stevens","Payne","Boyd","Sims","Brown"
      ],
      "suffix":["3rd","MA","BSc","","","","",""
      ]
    }
    ','$.name',5)
Returns: >
  a randomised string.
**/

RETURNS NVARCHAR(MAX)
AS
  BEGIN
    IF coalesce(@level,-1) < 0 RETURN 'too many levels'; /* if there is mutual 
references, this can potentially lead to a deadly embrace. This checks for that */
    IF IsJson(@JsonData) <> 0 --check that the data is valid
      BEGIN
        DECLARE @Choices TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @words TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @ii INT, @iiMax INT, @Output NVARCHAR(MAX);
        DECLARE @Endpunctuation VARCHAR(80); -- used to ensure we don't lose end punctuation
        DECLARE @SingleWord NVARCHAR(800), @ValidJsonList NVARCHAR(800);
		--we check for a missing or global reference and use the first object
        IF coalesce(@Reference,'$') = '$' 
		   SELECT top 1 @Reference = '$.'+[key] --just get the first
		     FROM OpenJson(@JSONData ,'$') where type=4;
        insert into @choices ([key],Value) --put the choices in a temp table
          SELECT [key],value FROM OpenJson(@JSONData ,@reference) where type=1
		-- if there was an easy way of getting the length of the array then we
		--could use JSON_VALUE ( expression , path ) to get the element   
        -- and get the chosen string
		DECLARE @string NVARCHAR(4000) =
           (SELECT TOP 1 value FROM @Choices 
		     CROSS JOIN RAN ORDER BY RAN.number);
        SELECT @ValidJsonList = N'["' + Replace(string_escape(@string,'json'), ' ', '","') + N'"]';
        IF IsJson(@ValidJsonList) = 0 RETURN N'invalid reference- '
                                             + @ValidJsonList;
        --now we examine each word in the string to see if it is reference
		--to another array within the JSON.
		INSERT INTO @words ([KEY], value)
		  SELECT [KEY], value
			FROM OpenJson( @ValidJsonList,'$');
        IF @@RowCount = 0 RETURN @ValidJsonList + ' returned no words';
        SELECT @ii = 0, @iiMax = Max([KEY]) FROM @words;
		-- we now loop through the words either treating the words as strings
		-- or symbols representing arrays
        WHILE (@ii < (@iiMax + 1))
          BEGIN
            SELECT @SingleWord = value FROM @words WHERE [KEY] = @ii;
            IF @@RowCount = 0
              BEGIN
                SELECT @Output =
                N'no words in' + N'["' + Replace(@string, ' ', '","') + N'"]';
                RETURN @Output;
              END;
            SELECT @ii = @ii + 1;
            IF Left(LTrim(@SingleWord), 1) = '^'-- it is a reference
              BEGIN -- nick out the '^' symbol
                SELECT @Reference = '$.' + Stuff(@SingleWord, 1, 1, ''),
                @Endpunctuation = '';
                WHILE Reverse(@Reference) LIKE '[:;.,-_()]%'
                  BEGIN --rescue any punctuation after the symbol
                    DECLARE @End INT = Len(@Reference);
                    SELECT @Endpunctuation = Substring(@Reference, @End, 1);
                    SELECT @Reference = Substring(@Reference, 1, @End - 1);
                  END; --and we call it recursively
                IF @level > 0
                  SELECT @Output =
                    Coalesce(@Output + ' ', '')
                    + dbo.SentenceFrom(@JsonData, @Reference, @level - 1)
                    + @Endpunctuation;
              END;
            -- otherwise it is plain sailing. Would that it were always
			-- that simple
            ELSE SELECT @Output = Coalesce(@Output + ' ', '') + @SingleWord;
          END;
      END;
    ELSE SELECT @Output = 'sorry. Error in the JSON';
    RETURN @Output; --and return whatever (it could be a novel!)
  END;
go
--  drop function [dbo].[SplitStringToWords]
--  drop function [dbo].[SplitStringToWords]