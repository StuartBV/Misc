CREATE TABLE [dbo].[FNOL_Policy]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Client] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Scheme] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyId] [int] NULL,
[Underwriter] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [int] NULL,
[DOB] [datetime] NULL,
[ServiceNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaritalStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rank] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regiment] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoverType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InceptionDate] [datetime] NULL,
[ChangeDate] [datetime] NULL,
[CancellationDate] [datetime] NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FNOL_Policy] ADD CONSTRAINT [PK_FNOL_Policy] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_policyno] ON [dbo].[FNOL_Policy] ([ID], [PolicyNo], [CustomerID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_serviceno] ON [dbo].[FNOL_Policy] ([ServiceNo]) ON [PRIMARY]
GO
