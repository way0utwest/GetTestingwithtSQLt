/*
Get Testing with tsqlt - Isolate Sproc Demo

Copyright 2014, Steve Jones and Red Gate Software

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.


Description:
This script will build a function to calculate a value, then test that. A procedure
will then be written to use this function, but we need to isolate the procedure from
the function for a good test.
*/
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--          Isolate Sproc Demo
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- We want to write a stored procedure to update our reading time
-- Isolate this from our function.

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--          Start Test  - Test our function first
--------------------------------------------------------------------------
--------------------------------------------------------------------------
/*
Create test
Class:
	Articles
Name:
	calculateEstimateOfReadingTime_CheckCalculation

FAILURE: change division at end of function
*/
CREATE PROCEDURE [Articles].[test calculateEstimateOfReadingTime_CheckCalculation]
AS
BEGIN

  --Assemble
  DECLARE @article VARCHAR(MAX)
	, @expresult INT
	, @actresult int
  SELECT @article = REPLICATE('alpha ', 1000)

  SELECT @expresult = 4

  -- act
  SELECT @actresult = dbo.calculateEstimateOfReadingTime(@article)
--  SELECT @actresult 'act', @expresult 'exp', len(@article), @article 'art'

  -- assert
  EXEC tsqlt.AssertEquals
    @Expected = @expresult,
    @Actual = @actresult, 
    @Message = N'Incorrect calculation of reading time';
  
END
go


--------------------------------------------------------------------------
--------------------------------------------------------------------------
--          End Test  
--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- execute test
EXEC tsqlt.run '[Articles].[test calculateEstimateOfReadingTime_CheckCalculation]';
GO














-- create a procedure to update the reading time for an article
-- 
CREATE PROCEDURE SetArticlesReadingEstimate
	@articleid AS int
AS
DECLARE @t TIME
 , @a VARCHAR(max)

SELECT
    @a = article
  FROM
    dbo.Articles A
  WHERE
    ArticlesID = @articleid;

SELECT
    @t = CONVERT(TIME, DATEADD(SECOND,
                               dbo.calculateEstimateOfReadingTime(@a),
                               0))

UPDATE
    dbo.Articles
  SET
    ReadingTimeEstimate = @t
  WHERE
    ArticlesID = @articleid

GO



-- quick developer check
select top 10
    ReadingTimeEstimate
  , *
  from
    dbo.Articles A
  where
    ArticlesID = 1;

EXEC dbo.SetArticlesReadingEstimate @articleid = 1;
go
select TOP 10
    ReadingTimeEstimate
  , *
  FROM
    dbo.Articles A
  where
    ArticlesID = 1;
go

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--          Start Test  - test our procedure
--------------------------------------------------------------------------
--------------------------------------------------------------------------
/*
Create test
Class:
	Articles
Name: 
	SetArticlesReadingEstimate_CheckCalculation
*/
CREATE PROCEDURE [Articles].[test SetArticlesReadingEstimate_CheckCalculation]
AS
BEGIN
 -- Assemble: 
 create table Articles.Expected
  (
    articlesid int
  , article varchar(max)
  , ReadingTimeEstimate time
  );

 exec tSQLt.FakeTable 'dbo.Articles';

 insert into dbo.Articles
    ( ArticlesID
    , Article
    , ReadingTimeEstimate
    )
  values
    ( 10
    , replicate('a', 325)
    , null
    )

 insert Articles.Expected
    ( articlesid
    , article
    , ReadingTimeEstimate
    )
  values
    ( 10
    , -- articleid
      replicate('a', 325)
    , -- article
      '00:05:25'  -- readingtime
    )

 exec tSQLt.FakeFunction @FunctionName = N'dbo.calculateEstimateOfReadingTime', -- nvarchar(max)
  @FakeFunctionName = N'Articles.FakeReadingTime325'
 -- nvarchar(max)

 

 -- Act:
 exec dbo.SetArticlesReadingEstimate @articleid = 10
 -- int


 -- Assert:
 exec tsqlt.AssertEqualsTable @Expected = N'Articles.expected',
  @Actual = N'dbo.articles', @FailMsg = N'The reading estimate is incorrect.';
END
GO

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--          End Test  
--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- Test Fails
-- here's our function for the update test
CREATE FUNCTION Articles.FakeReadingTime325 ( @value varchar(MAX) )
RETURNS int
 AS
      BEGIN
        RETURN 325
      END
;
go


-- run test
EXEC tsqlt.run '[Articles].[test SetArticlesReadingEstimate_CheckCalculation]';
GO




-- alter procedure
-- test by removing the update
ALTER PROCEDURE SetArticlesReadingEstimate
	@articleid AS int
AS
DECLARE @t TIME
 , @a VARCHAR(max)

SELECT
    @a = article
  FROM
    dbo.Articles A
  WHERE
    ArticlesID = @articleid;

SELECT
    @t = CONVERT(TIME, DATEADD(SECOND,
                               dbo.calculateEstimateOfReadingTime(@a),
                               0))
/*
UPDATE
    dbo.Articles
  SET
    ReadingTimeEstimate = @t
  WHERE
    ArticlesID = @articleid
*/
GO

-- run test
exec tsqlt.Run @TestName = N'[Articles].[test SetArticlesReadingEstimate_CheckCalculation]'
;
go






-- fix proc again
-- alter procedure
ALTER PROCEDURE SetArticlesReadingEstimate
	@articleid AS int
AS
DECLARE @t TIME
 , @a VARCHAR(max)

SELECT
    @a = article
  FROM
    dbo.Articles A
  WHERE
    ArticlesID = @articleid;

SELECT
    @t = CONVERT(TIME, DATEADD(SECOND,
                               dbo.calculateEstimateOfReadingTime(@a),
                               0))

UPDATE
    dbo.Articles
  SET
    ReadingTimeEstimate = @t
  WHERE
    ArticlesID = @articleid
return
;
GO


-- run test
exec tsqlt.Run @TestName = N'[Articles].[test SetArticlesReadingEstimate_CheckCalculation]'
;
GO


--------------------------------------------------------------------------
--------------------------------------------------------------------------
--          End Demo
--------------------------------------------------------------------------
--------------------------------------------------------------------------

