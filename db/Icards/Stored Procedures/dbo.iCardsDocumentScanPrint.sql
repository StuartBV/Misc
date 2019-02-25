SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[iCardsDocumentScanPrint]
@scanID int=0,
@userid UserID
AS
set nocount on
set transaction isolation level read uncommitted

select d.scanID, cc.ClaimNoPrefix + CAST(d.ICardsID AS varchar) AS iCardsID,
	isnull(e.fname,'Error') + ' ' + isnull(e.sname,' Unknown User') EmpName,
	InitialFax, OtherInfo, d.createdate
from documentscans d join policies p on p.iCardsID=d.iCardsID
join card_companies cc on cc.ID=p.companyID
left join ppd3.dbo.logon l on l.userid=d.createdby
left join ppd3.dbo.employees e on l.UserFK=e.[ID]
where 1=case when d.scanID=@scanID and d.printed=0 and d.createdby=@userid then 1 else --pulls details of only one scan header
		case when @scanID=0 and d.printed=0 and d.createdby=@userid then 1 else 0 end -- pulls details of all scan headers for said user
	end
	
GO
