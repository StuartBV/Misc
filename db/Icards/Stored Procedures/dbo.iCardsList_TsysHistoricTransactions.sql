SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[iCardsList_TsysHistoricTransactions]
@CardID int

AS

set dateformat dmy
set transaction isolation level read uncommitted

select cd.id as [cardid], 
	hs.Postedamount as cardvalue,  
	case when hs.SettlementType in ('credit','debit') then 'Add/Subtract Value' else hs.SettlementType end as TransType, 
	hs.Merchant as Merchant,
	hs.MerchantCity as Location,
	hs.AuthCode, 
	convert(char(10),hs.SettlementDate,103) createdate,
	'Tsys' as createdby,
	isnull(s1.code,-1) CardType
from	dbo.Cards AS cd 
		join dbo.Customers AS cu ON cd.CustomerId = cu.ID
		join dbo.policies AS p ON cu.iCardsID = p.ICardsID
		join dbo.Card_companies AS cc on cc.ID = p.CompanyID and cc.id=1		
		join dbo.History_UserData hu on hu.ExternalID=cc.ClaimNoPrefix + CAST(p.ICardsID AS varchar)
		join dbo.History_Settlements hs on hu.UserID=hs.UserID
		left join SysLookup s1 on s1.TableName='CardType' and s1.flags=hu.ProgramID
where cd.ID=@CardID
order by cast(replace(hs.SettlementDate,'-','') as datetime) desc                         
                      
set transaction isolation level read committed  
GO
