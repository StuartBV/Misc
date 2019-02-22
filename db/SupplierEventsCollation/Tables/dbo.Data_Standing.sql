CREATE TABLE [dbo].[Data_Standing]
(
[MessageID] [int] NOT NULL,
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Data_Standing_SourceSystem] DEFAULT ('CMS'),
[EventID] [int] NOT NULL,
[EventType] [tinyint] NOT NULL CONSTRAINT [DF_Data_Standing_EventType] DEFAULT ((1)),
[MessageType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Data_Standing_MessageType] DEFAULT ('E'),
[SupplierID] [int] NOT NULL,
[SourceKey] [int] NOT NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Excess] [smallmoney] NULL,
[OriginatingOffice] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceClaimNo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurancePolicyNo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [int] NULL,
[InvoiceSent] [smalldatetime] NULL,
[InvoiceTotal] [money] NULL,
[IncidentDate] [smalldatetime] NULL,
[ClaimReceivedDate] [smalldatetime] NULL,
[Delegated] [tinyint] NULL,
[Title] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_StandingData_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_StandingData_CreatedBy] DEFAULT ('sys'),
[Data] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Data_Standing_Data] DEFAULT (''),
[CPLEstimateID] AS (case [sourcesystem] when 'cms' then 'C' when 'ordering' then 'OS' end+((((CONVERT([varchar],[SourceKey],(0))+'/')+CONVERT([varchar],[supplierID],(0)))+'/')+[Data]))
) ON [Data]
GO
ALTER TABLE [dbo].[Data_Standing] ADD CONSTRAINT [PK_StandingData] PRIMARY KEY CLUSTERED  ([MessageID]) WITH (FILLFACTOR=100) ON [Data]
GO
CREATE NONCLUSTERED INDEX [Idx_EventID] ON [dbo].[Data_Standing] ([EventID]) ON [Data]
GO
CREATE NONCLUSTERED INDEX [IX_ClaimID] ON [dbo].[Data_Standing] ([SourceKey], [SupplierID], [MessageType]) WITH (FILLFACTOR=70, PAD_INDEX=ON) ON [Indexes]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Data_Standing', 'COLUMN', N'EventID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=Data to send (send cancel msg if necessary followed by new estimate msg); 1=No Data to Send (send cancel msg only); ', 'SCHEMA', N'dbo', 'TABLE', N'Data_Standing', 'COLUMN', N'EventType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'E=Estimate, I=Invoice', 'SCHEMA', N'dbo', 'TABLE', N'Data_Standing', 'COLUMN', N'MessageType'
GO
