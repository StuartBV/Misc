CREATE TABLE [dbo].[Products]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgeInMonths] [int] NOT NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Completed] [bit] NOT NULL,
[Number] [int] NOT NULL,
[CategoryId] [int] NULL,
[SpecificValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemId] [int] NOT NULL,
[OtherValuationBasisText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementId] [int] NULL,
[ClaimId] [int] NOT NULL,
[SubCategoryId] [int] NULL,
[ValidatedAmount] [decimal] (18, 2) NULL,
[Value] [decimal] (18, 2) NULL,
[ValuationBases] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecificationName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecificationValues] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IceProductGuid] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [PK_dbo.Products] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ClaimId] ON [dbo].[Products] ([ClaimId]) ON [PRIMARY]
GO
