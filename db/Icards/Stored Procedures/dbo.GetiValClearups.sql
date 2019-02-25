SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetiValClearups] as

select distinct cc.ClaimNoPrefix + cast(p.ICardsID as varchar) as iCardsID, p.Status, p.InsurancePolicyNo, 
p.InsuranceClaimNo, p.IValRef, cu.LastName, cu.PostCode, 
convert(char(10), p.CreateDate, 103) + ' ' + convert(char(5), p.CreateDate, 14) as CreateDate, 
sys.Description as CardType, p.wizardstage, wiz.Description as stage, cd.ID as cardid, 
convert(char(8), p.AlteredDate, 8) as time, coalesce (e.FName + ' ' + e.SName, 'Administrator') as empname, 
p.ICardsID as seq, p.AlteredBy,convert(char(10), p.AlteredDate, 103) + ' ' + convert(char(5), 
p.AlteredDate, 14) as AlteredDate
from Card_companies as cc join policies as p on cc.ID=p.CompanyID
join Customers as cu on cu.iCardsID=p.ICardsID
join Cards as cd on cd.CustomerId=cu.ID
left join SysLookup as sys on sys.Code=cd.CardType and sys.TableName='CardType'
left join PPD3.dbo.Logon as l on p.AlteredBy=l.UserID
left join PPD3.dbo.employees as e on e.Id=l.UserFK
left join transactions as cv on cv.CardID=cd.ID
left join SysLookup as wiz on wiz.Code=p.wizardstage and wiz.TableName='wizardstage' 
where convert(varchar(12),p.createdate,113)=convert(varchar(12),getdate(),113) and p.ivalref is not null and cv.cardvalue != 0
GO
