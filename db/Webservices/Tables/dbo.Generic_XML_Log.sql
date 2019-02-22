CREATE TABLE [dbo].[Generic_XML_Log]
(
[LID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[SupplierID] [int] NULL,
[Direction] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MsgType] [int] NULL,
[XML] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XMLResponse] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [tinyint] NULL,
[CreateDate] [datetime] NULL
) ON [PRIMARY]
GO
