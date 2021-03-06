CREATE TABLE [dbo].[MI_NU_ReportingTable]
(
[ClaimID] [int] NOT NULL,
[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PPDRef] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstructingUnit] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherClaimsCentre] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimsCentre] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SepsCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimReference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncidentDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstructionDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstActionDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfAgreement] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Commodity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supplier] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUInvoiceAmount] [decimal] (8, 2) NULL,
[NUInvoiceVat] [decimal] (8, 2) NULL,
[PPInvoiceDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cause] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Surname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Delegated] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Outcome] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquivilentItemCost] [smallmoney] NULL,
[Discount] [decimal] (8, 2) NULL,
[ItemCost] [decimal] (8, 2) NULL,
[PHUpgrade] [decimal] (8, 2) NULL,
[InspectionFee] [decimal] (8, 2) NULL,
[DeliveryFee] [decimal] (8, 2) NULL,
[DisposalFee] [decimal] (8, 2) NULL,
[Ancillaries] [decimal] (8, 2) NULL,
[HandlingFee] [decimal] (8, 2) NULL,
[Excess] [smallmoney] NULL,
[RepairAmount] [decimal] (8, 2) NULL,
[NoItems] [int] NULL,
[QuoteOnly] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MICompletedDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CancelDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX1] ON [dbo].[MI_NU_ReportingTable] ([PPDRef], [Commodity]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
