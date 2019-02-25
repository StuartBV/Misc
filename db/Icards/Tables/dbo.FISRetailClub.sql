CREATE TABLE [dbo].[FISRetailClub]
(
[Mrchid] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Descr] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MrchLoc] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_FISRetailClub_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[AIID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
