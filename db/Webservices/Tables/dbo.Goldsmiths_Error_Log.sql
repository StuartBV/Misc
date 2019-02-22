CREATE TABLE [dbo].[Goldsmiths_Error_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[ErrorTime] [datetime] NULL CONSTRAINT [DF_Goldsmiths_Error_Log_ErrorTime] DEFAULT (getdate()),
[ErrorText] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Goldsmiths_Error_Log] ADD CONSTRAINT [PK_Goldsmiths_Error_Log] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
