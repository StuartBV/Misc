SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsListRedemptions]
@CardID int=0
as
set transaction isolation level read uncommitted

if @CardID=0
select cc.ClaimNoPrefix + cast(p.ICardsID as varchar) as iCardsID, r.ID RedemptionID, r.CashSettled, r.currentcardvalue, r.lasttransactionlocation,
	r.LastTransactionDate, r.cardnumber, r.cardblockedonTsys, r.cardblockedDate, p.[Status],
	cu.LastName, cu.PostCode, isnull(sys.[description],'') as CardType, p.wizardstage,
	convert(char(10),r.CreateDate,103)+' '+convert(char(5),r.CreateDate,14) as CreateDate,
	coalesce (e.FName + ' ' + e.SName, 'Administrator') as createdby,
	p.alteredby,
	convert(char(8),p.alteredDate,8) [time],
	coalesce (e2.FName + ' ' + e2.SName, 'Administrator') as empname,
	t.BatchFileUploaded
from redemptions r join cards cd on cd.[ID]=r.cardID
join customers cu on cu.[ID]=cd.customerID
join policies p on p.customerID=cu.[ID]
join card_companies cc on cc.[ID] = p.CompanyID
left join syslookup sys on sys.code=cd.cardtype and tablename='CardType'
left join ppd3.dbo.logon l on r.createdby=l.UserID
left join ppd3.dbo.employees e on e.[Id] = l.UserFK
left join ppd3.dbo.logon l2 on p.alteredby=l2.UserID
left join ppd3.dbo.employees e2 on e2.[Id] = l2.UserFK
join transactions t on t.CardID= r.CardID
where r.redeemed =0 and p.wizardstage=4
and (r.CardActivated=0 or (datediff(d,r.CreateDate,getdate())>10 and r.CardActivated=1))
and r.ID >=218
order by cc.ClaimNoPrefix + cast(p.ICardsID as varchar) desc
else
select CardActivated, convert(char(10),CardActivatedDate,103) as CardActivatedDate, 	isnull(CurrentCardValue,0) CurrentCardValue,
	isnull(CardValueOnCompletion,0) CardValueOnCompletion, Redeemed, convert(char(10),RedeemedDate,103) as RedeemedDate,
	convert(char(10),CreateDate,103)+' '+convert(char(5),CreateDate,14) as CreateDate
from Redemptions
where CardID=@CardID 
order by createdate desc
	
GO
