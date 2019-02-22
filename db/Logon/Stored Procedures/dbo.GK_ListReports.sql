SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_ListReports]
	@hash varchar (50)
AS
set nocount on
set transaction isolation level read uncommitted

if exists (select * from userdata u  where [hash] = @hash)
begin
	Select sl.Description,sl.ExtraDesc,u.clientid 
	from Userdata u 
	Join ClientApps ca  on u.clientid = ca.cid
	Join Syslookup sl  on sl.code = ca.aid and sl.tablename='reports'
	where hash = @hash
	and 1=case when ca.cid = 1 then 1 else 
	case when ca.cid !=1 and sl.extracode is null then 1 else 0 end end
end

set transaction isolation level read committed
GO
