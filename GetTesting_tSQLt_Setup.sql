/*
Get Testing with tSQLt

Setup script

-- create articles
-- add data to articles
-- create RSSFeeds
-- create Contacts
-- create Blogs
-- create v_articles


*/
use [SimpleTalkDev_Steve]
go
create table [dbo].[Articles](
	[ArticlesID] [int] identity(1,1) not null,
	[AuthorID] [int] null,
	[Title] [char](142) null,
	[Description] [varchar](max) null,
	[Article] [varchar](max) null,
	[PublishDate] [datetime] null,
	[ModifiedDate] [datetime] null,
	[URL] [char](200) null,
	[Comments] [int] null,
 constraint [PK_Article] primary key clustered 
(
	[ArticlesID] asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [PRIMARY]
) on [PRIMARY] textimage_on [PRIMARY]
go


-- insert data into articles
INSERT INTO dbo.Articles
    ( AuthorID
    , Title
    , Description
    , Article
    , PublishDate
    , ModifiedDate
    , URL
    , Comments
    )
  values
    ( 1, 'What Counts For a DBA: Bravery', '',  ''
    , -- Article
      getdate()
    , -- PublishDate
      getdate()
    , -- ModifiedDate
      ''
    , -- URL
      0  -- Comments
    )

go

-- create rssfeeds
create table [dbo].[RSSFeeds](
	[RSSFeedID] [int] identity(1,1) not null,
	[FeedName] [varchar](max) null,
	[Checked] [bit] null,
	[FeedBurner] [bit] not null,
 constraint [PK__RSSFeeds__DF1690F2C1F77AC5] primary key clustered 
(
	[RSSFeedID] asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [PRIMARY]
) on [PRIMARY] textimage_on [PRIMARY]
;
go

-- add data to rss feeds

go

-- create Contacts
create table [dbo].[Contacts](
	[ContactsID] [int] identity(1,1) not null,
	[ContactFullName] [nvarchar](100) not null,
	[PhoneWork] [nvarchar](25) null,
	[PhoneMobile] [nvarchar](25) null,
	[Address1] [nvarchar](128) null,
	[Address2] [nvarchar](128) null,
	[Address3] [nvarchar](128) null,
	[CountryCode] [nvarchar](4) null,
	[JoiningDate] [datetime] null,
	[ModifiedDate] [datetime] null,
	[Email] [nvarchar](256) null,
	[Photo] [image] null,
 constraint [PK__Contacts__912F378B7C53D1A0] primary key clustered 
(
	[ContactsID] asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [PRIMARY]
) on [PRIMARY] textimage_on [PRIMARY]
;

go

-- create country codes

CREATE TABLE [dbo].[CountryCodes](
	[CountryName] [nvarchar](255) NULL,
	[CountryCode] [nvarchar](4) NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
;
go
-- insert data into country codes

go

-- create v_articles
create view [dbo].[v_Articles]
as
    select  top 250 a.[Title] ,
            a.[PublishDate] ,
            a.[Description] ,
            a.[URL] ,
            a.[Comments], 
			dbo.calculateEstimateOfReadingTime(a.Article) as readingTime,
            c.[ContactFullName] ,
			c.[Photo],
			cc.CountryCode,
			cc.CountryName
    from    Articles a
		        left join Contacts c on a.AuthorID = c.ContactsID
			left join dbo.CountryCodes cc on c.CountryCode = cc.Countrycode
;
go


-- create function - calculateEstimateOfReadingTime

create function [dbo].[calculateEstimateOfReadingTime] ( @value varchar(max) )
returns int
as
    begin
      declare
        @ret as int = 1
      , @i as int = 1;
      while @i <= len(@value)
        begin
          if substring(@value, @i, 1) = ' '
            begin
              set @ret = @ret + 1;
            end
          set @i = @i + 1;
        end
      return @ret / 250;

    end
;

go

