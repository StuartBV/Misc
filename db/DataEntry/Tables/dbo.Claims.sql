CREATE TABLE [dbo].[Claims]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ClaimId] [int] NOT NULL,
[InsuranceClaimNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurancePolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_Claims_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Claims] ADD CONSTRAINT [PK_Claims] PRIMARY KEY CLUSTERED  ([ClaimId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Id] ON [dbo].[Claims] ([Id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
