CREATE TABLE [dbo].[MU_NU_InspectionSuperFmt]
(
[ClaimID] [int] NOT NULL,
[SuperFmt] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MU_NU_InspectionSuperFmt] ADD CONSTRAINT [PK_MU_NU_InspectionSuperFmt] PRIMARY KEY CLUSTERED  ([ClaimID], [SuperFmt]) ON [PRIMARY]
GO
