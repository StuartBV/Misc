SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[DocScanPrintList]
@userid UserID
as
set nocount on
set transaction isolation level read uncommitted
select d.claimid, c.clientrefno, scanID, sheets, isnull(e.fname,'Error') + ' ' + isnull(e.sname,' Unknown User') EmpName, d.createdate, d.scanID, printed, 
	case when uploaded is null then 0 else 1 end uploaded
from DocumentScanHeaders d 
join fnol_claims c  on c.claimid=d.claimid
left join ppd3.dbo.Logon l on l.userid=d.createdby
left join ppd3.dbo.Employees e on l.UserFK=e.[ID]
where uploaded is null and cancelled is null and d.createdby=@userid

GO
