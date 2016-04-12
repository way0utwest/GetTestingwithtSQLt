-- SQT_Cleanup
-- 
-- Clean all tests from tsqlt
drop procedure tArticles.[test Articles_Check_Metadata];
drop procedure tArticles.[test calculateEstimateOfReadingTime];
drop procedure tArticles.[test SetArticlesReadingEstimate_NoParameter];
drop procedure tRSSFeeds.[test RSSFeeds_CheckColumns];
drop procedure tArticles.[test SetArticlesReadingEstimate_CheckCalculation];
drop procedure tContacts.[test CheckContactfullName for Space];
drop procedure tContacts.[test CheckValidEmail];
drop procedure tRSSFeeds.[test RSSFeeds for Nullable Columns];
go
exec tsqlt.DropClass @ClassName = N'tArticles';
exec tsqlt.DropClass @ClassName = N'tBlogs';
exec tsqlt.DropClass @ClassName = N'tContacts';
exec tsqlt.DropClass @ClassName = N'tRSSFeeds';
exec tsqlt.DropClass @ClassName = N'tv_articles';
exec tsqlt.DropClass @ClassName = N'tAcceptanceTests';
exec tsqlt.DropClass @ClassName = N'tCITests';
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


 

