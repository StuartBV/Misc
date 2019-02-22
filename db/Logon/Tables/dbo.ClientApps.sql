CREATE TABLE [dbo].[ClientApps]
(
[CID] [int] NOT NULL,
[AID] [int] NOT NULL,
[starttime] [smalldatetime] NULL CONSTRAINT [DF_ClientApps_starttime] DEFAULT ('1900-01-01 08:00:00.000'),
[endtime] [smalldatetime] NULL CONSTRAINT [DF_ClientApps_endtime] DEFAULT ('1900-01-01 20:00:00.000'),
[searches] [smallint] NULL CONSTRAINT [DF_ClientApps_searches] DEFAULT ((20)),
[validations] [smallint] NULL CONSTRAINT [DF_ClientApps_validations] DEFAULT ((20)),
[Duration] [int] NULL CONSTRAINT [DF_ClientApps_Duration] DEFAULT ((60)),
[Itemdetails] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [dbo].[TR_ClientApps_Insert] on [dbo].[ClientApps] 
for insert
as
set nocount on
-- Create Default ClaimView access of "Nothing" e.g. sys.flags=0 for Client when Client Apps has ClaimView added. 
-- Claimview App is ID=1

-- If we have just inserted the claimview client app then add.
insert into logon.dbo.syslookup (TableName,Code,[Description],Flags,ExtraCode,CreateDate,CreatedBy)

select 'CVModulesAccess' as tablename,c.cid as code,c.name as [description],0 as flags,sys.code as extracode,getdate() as createdate,'CA trigger' as createdby
from inserted i join clients c on c.cid=i.cid
join syslookup sys on TableName='CVModules'
where i.aid=1
and not exists (select * from syslookup sl where sl.tablename='CVModulesAccess' and cast(sl.code as int)=i.cid)
-- and name is not new client. That would be silly. Handled in Trigger called "ClientAppsInsertCVModuleAccess" on logon.dbo.clients table.
and c.name != 'New Client'
order by c.cid
GO
ALTER TABLE [dbo].[ClientApps] ADD CONSTRAINT [PK_Table1] PRIMARY KEY CLUSTERED  ([CID], [AID]) ON [PRIMARY]
GO
