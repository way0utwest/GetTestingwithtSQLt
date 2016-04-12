-- SQT_Cleanup
-- 
-- Clean all tests from tsqlt
drop procedure Articles.[test Articles_Check_Metadata];
drop procedure Articles.[test calculateEstimateOfReadingTime];
drop procedure Articles.[test SetArticlesReadingEstimate_NoParameter];
drop procedure RSSFeeds.[test RSSFeeds_CheckColumns];
drop procedure Articles.[test SetArticlesReadingEstimate_CheckCalculation];
drop procedure Contacts.[test CheckContactfullName for Space];
drop procedure Contacts.[test CheckValidEmail];
drop procedure RSSFeeds.[test RSSFeeds for Nullable Columns];
go
exec tsqlt.DropClass @ClassName = N'Articles';
exec tsqlt.DropClass @ClassName = N'Blogs';
exec tsqlt.DropClass @ClassName = N'Contacts';
exec tsqlt.DropClass @ClassName = N'RSSFeeds';
exec tsqlt.DropClass @ClassName = N'v_articles';
exec tsqlt.DropClass @ClassName = N'AcceptanceTests';
exec tsqlt.DropClass @ClassName = N'CITests';
go

-- drop procedures and functions
drop procedure dbo.SetArticlesReadingEstimate;
drop procedure dbo.uspGetArticles;
drop function Articles.FakeReadingTime325;
go

-- drop table column
alter table Articles
  drop column ReadingTimeEstimate;
go


 

