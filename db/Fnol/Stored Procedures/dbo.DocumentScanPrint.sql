SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocumentScanPrint]
@userid varchar(20)
AS
set nocount on
Set transaction isolation level read uncommitted
select claimid, sheets, isnull(e.fname,'Error') + ' ' + isnull(e.sname,' Unknown User') EmpName,
	QuoteInstruction, ReplaceInstruction, ItemList, 
	ToInsCo, FromInsCo, ToLA, 
	FromLA, ToInsured, FromInsured, 
	ToOther, FromOther, d.createdate
from documentscans d 
left join Logon l on l.userid=d.userid
left join Employees e on l.UserFK=e.[ID]
where printed=0 and d.userid=@userid

Set transaction isolation level read committed

GO
