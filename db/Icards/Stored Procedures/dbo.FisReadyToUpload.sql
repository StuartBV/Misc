SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[FisReadyToUpload] as

select cc.ClaimNoPrefix + cast(p.ICardsID as varchar) as iCardsID, 
p.[status], 
p.InsurancePolicyNo,        
isnull(cu.Title,'')+' '+isnull(cu.FirstName,'')+' '+isnull(cu.LastName,'') as LastName, 
cu.PostCode, 
convert(char(10), p.CreateDate, 103) + ' ' + convert(char(5), p.CreateDate, 14) as CreateDate, 
sys.[description] as CardType, 
p.wizardstage, 
wiz.[description] as stage, 
convert(char(8), p.AlteredDate, 8) as time, 
coalesce (e.FName + ' ' + e.SName, 'Administrator') as empname, 
p.AlteredBy,
convert(char(10), p.AlteredDate, 103) + ' ' + convert(char(5), p.AlteredDate, 14) as AlteredDate
from         
dbo.Card_companies as cc inner join
dbo.policies as p on cc.ID = p.CompanyID inner join
dbo.Customers as cu on cu.iCardsID = p.ICardsID inner join
dbo.Cards as cd on cd.CustomerId = cu.ID left outer join
dbo.SysLookup as sys on sys.Code = cd.CardType and sys.TableName = 'CardType' left outer join
PPD3.dbo.Logon as l on p.AlteredBy = l.UserID left outer join
PPD3.dbo.employees as e on e.Id = l.UserFK left outer join
dbo.transactions as t on t.CardID = cd.ID left outer join
dbo.SysLookup as wiz on wiz.Code = p.wizardstage and wiz.TableName = 'wizardstage' 
where t.[status] =1 and p.wizardstage=4 
and p.cancelreason is null
and (t.authrequirement=0 or (t.authrequirement>0 and t.authdate is not null))
and cc.id=2
and t.InvoiceBatchNo is null
and t.InvoicedDate is null
GO
