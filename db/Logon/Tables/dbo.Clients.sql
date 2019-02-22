CREATE TABLE [dbo].[Clients]
(
[CID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Image] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Text] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent] [int] NULL,
[InsuranceCoID] [int] NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_Clients_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierID] [int] NULL CONSTRAINT [DF_Clients_Type] DEFAULT ((0)),
[Superfmt] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GKVersion] [tinyint] NOT NULL CONSTRAINT [DF_Clients_GKVersion] DEFAULT ((1)),
[Enabled] [bit] NOT NULL CONSTRAINT [DF_Clients_Enabled] DEFAULT ((0)),
[Type] [tinyint] NOT NULL CONSTRAINT [DF_Clients_ClientType] DEFAULT ((1)),
[OUPath] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[ClientAppsCreateGateKeeper] ON [dbo].[Clients] 
FOR INSERT
AS

--create a default Gatekeeper App for any new clients.
insert into logon.dbo.clientapps (cid,aid)
select cid, 0 from inserted
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[ClientAppsInsertCVModuleAccess] ON [dbo].[Clients] 
FOR UPDATE
AS

-- Create Default ClaimView access of "Nothing" e.g. sys.flags=0 for Client when Client Apps has ClaimView added. 
-- Claimview App is ID=1

-- If we have updated the Name from 'New Client'
if update([name])
begin
	insert into logon.dbo.syslookup ([TableName],
		[Code],
		[Description],
		[Flags],
		[ExtraCode],
		[CreateDate],
		[CreatedBy])
	
	
	select 'CVModulesAccess' as tablename,c.cid as code,c.[name] as [description],0 as flags,sys.code as extracode,getdate() as createdate,'C trigger' as createdby
	from inserted c
	join [ClientApps] ca (nolock) on ca.[CID]=c.cid and ca.aid=1 -- only ClaimView App
	join syslookup sys (nolock) on [TableName]='CVModules'
	where not exists (select * from syslookup (nolock) where tablename='CVModulesAccess' and code=cast(c.cid as varchar) )
	order by c.cid
end
GO
ALTER TABLE [dbo].[Clients] ADD CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED  ([CID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicating a Parent Company over these Clients.', 'SCHEMA', N'dbo', 'TABLE', N'Clients', 'COLUMN', N'Parent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Depicts type of commodity this supplier is allowed to see', 'SCHEMA', N'dbo', 'TABLE', N'Clients', 'COLUMN', N'Superfmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Client 0=Client,1=Supplier', 'SCHEMA', N'dbo', 'TABLE', N'Clients', 'COLUMN', N'SupplierID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=Internal,1=Client,2=Supplier,3=Assessor', 'SCHEMA', N'dbo', 'TABLE', N'Clients', 'COLUMN', N'Type'
GO
