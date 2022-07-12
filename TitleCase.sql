USE [PhilFactor]
GO
/****** Object:  UserDefinedFunction [dbo].[Capitalize]    Script Date: 05/01/2018 10:47:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or ALTER FUNCTION [dbo].[TitleCase](@string NVARCHAR(MAX))
/**
Summary: >
  Capitalise all words five letters and longer. 
  Even if the words are prepositions or conjunctions, 
  lower case all other conjunctions, prepositions and articles
  capitalise first and last word

Author: PhilFactor
Date: 05/01/2020
Database: PhilsScripts
Examples:
   - SELECT  dbo.TitleCase('god save her majesty') --God save her majesty
Returns: >
  Returns a copy of the string with only its first character capitalized.
**/
RETURNS NVARCHAR(MAX)
AS
BEGIN

DECLARE @StringLength INT, @Start INT, @end INT, @Cursor INT,@WordLength INT,
@word Nvarchar(200),@output NVARCHAR(MAX),@wordNumber int

SELECT @Cursor=1, @StringLength=LEN(@string),@WordNumber=0
WHILE @cursor<@StringLength
  BEGIN
  SELECT @start=PATINDEX('%[^A-Za-z0-9][A-Za-z0-9%]%',
          ' '+SUBSTRING (@string,@cursor,50)
          )-1
  if @start<0 break        
  SELECT @WordLength=PATINDEX('%[^A-Z''a-z0-9-%]%',SUBSTRING (@string,@cursor+@start+1,50)+' '),
  @WordNumber=@Wordnumber+1, 
  @word=SUBSTRING(@string,@cursor+@start,@WordLength)
  if @Wordnumber=1 --first word
  or @word not in ('of','in','to','for','with','on','at','from','by','as','into','like','over',
                  'out','and','that','but','or','as','if','when','than','so','nor','like',
				  'once','now','a','an','the')
  SELECT @string  =
        Stuff(
               @string ,  @cursor+@start, 1,
               Upper(Substring(@string , @cursor+@start, 1))
             );
  SELECT @Cursor=@Cursor+@Start+@WordLength+1,@WordNumber=@Wordnumber+1
  END
RETURN @string
END
go
