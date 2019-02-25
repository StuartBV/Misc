SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsDocumentScanList]
@userid UserID
as

set nocount on
set transaction isolation level read uncommitted

select d.ScanID, cc.ClaimNoPrefix + cast(d.ICardsID as varchar) as iCardsID,
cu.LastName, cu.PostCode, InitialFax, OtherInfo,
sys.description as CardType, d.createdate
from documentscans d join policies p on p.iCardsID=d.iCardsID
join card_companies cc on cc.ID=p.companyID
left join customers cu on cu.ICardsID = p.ICardsID
left join cards cd on cd.CustomerId = cu.ID
left join ppd3.dbo.logon l on l.userid=d.createdby
left join ppd3.dbo.employees e on l.UserFK=e.[ID]
left join syslookup sys on sys.code=cd.cardtype and sys.tablename='CardType'
where d.printed=0 and d.createdby=@userid and deleted=0
group by d.scanID, d.ICardsID, cu.LastName, cu.PostCode, InitialFax, OtherInfo, sys.[description], d.createdate,
cc.ClaimNoPrefix
GO
