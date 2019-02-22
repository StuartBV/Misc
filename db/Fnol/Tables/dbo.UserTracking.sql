CREATE TABLE [dbo].[UserTracking]
(
[UserID] [dbo].[UserID] NOT NULL,
[ID] [int] NOT NULL,
[DocType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NOT NULL,
[Comments] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserTracking] ADD CONSTRAINT [PK_UserTracking] PRIMARY KEY NONCLUSTERED  ([ID], [DocType], [Date], [UserID]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [Idx_Date] ON [dbo].[UserTracking] ([Date], [DocType]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
