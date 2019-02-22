CREATE TABLE [dbo].[FNOL_PolicyLimits]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PolicyID] [int] NOT NULL,
[SumInsured] [money] NULL,
[Excess] [money] NULL,
[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FNOL_PolicyLimits] ADD CONSTRAINT [PK_FNOL_PolicyLimits] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_policyid] ON [dbo].[FNOL_PolicyLimits] ([PolicyID]) ON [PRIMARY]
GO
