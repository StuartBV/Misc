SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_CV_ListClientAccess] 
AS
set transaction isolation level read uncommitted

Select c.cid ClientID,c.name CientName, sys.[Description] ModuleName,-- cva.flags,
case when isnull(cva.flags,0)=0 then 'No' else 'Yes' end as Access
from logon.dbo.[Clients] c
join logon.dbo.syslookup sys on sys.tablename='CVModules'
left join logon.dbo.syslookup cva on cva.tablename='CVModulesAccess' 
	and sys.code = cva.[ExtraCode] and c.cid=cast(cva.code as int)
order by c.cid

set transaction isolation level read committed
GO
