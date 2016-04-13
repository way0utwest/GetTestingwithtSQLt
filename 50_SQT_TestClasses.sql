/*
Get Testing with tsqlt - Build Test Classes

Copyright 2014, Steve Jones and Red Gate Software

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.


Description:
This script will add test clases for the Simple Talk demo application.
*/

----------------------------------------------------------------------
----------------------------------------------------------------------
-- Classes
----------------------------------------------------------------------
----------------------------------------------------------------------

-- Broup by object
-- Get a list of tables
select top 10
    TABLE_CATALOG
  , TABLE_SCHEMA
  , TABLE_NAME
  , TABLE_TYPE
  from
    INFORMATION_SCHEMA.TABLES T
  where TABLE_SCHEMA != 'tsqlt';


-- show SQLTest
exec tSQLt.NewTestClass @ClassName = N'RSSFeeds';
exec tSQLt.NewTestClass @ClassName = N'Contacts';
exec tSQLt.NewTestClass @ClassName = N'Blogs';
exec tSQLt.NewTestClass @ClassName = N'CountryCodes';
exec tSQLt.NewTestClass @ClassName = N'v_articles';
-- etc.






-- group by testing type
exec tSQLt.NewTestClass @ClassName = N'CITests';
exec tSQLt.NewTestClass @ClassName = N'AcceptanceTests';







-- execute by class
exec tSQLt.RunTestClass @TestClassName = N'Blogs' -- nvarchar(max)




-- test
-- blogs, check blank author name

-- contacts - check fullname
create procedure [Contacts].[test CheckContactFullName for Space]
as
  begin
-- Assemble
    create table Articles.Expected
      (
        ContactFullName varchar(200)
      );

-- Act
    insert into Articles.Expected
        select
            ContactFullName
          from
            dbo.Contacts C
          where
            charindex(' ', ContactFullName) = 0;

-- Assert
    exec tsqlt.AssertEmptyTable @TableName = N'Articles.Expected';

  end

-- contacts check valid email
-- rssfeeds, check names of columns

GO

EXEC tsqlt.runall;
