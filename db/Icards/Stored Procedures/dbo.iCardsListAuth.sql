SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsListAuth]
@level int=0,
@userid UserID=''

as
set transaction isolation level read uncommitted

select cc.ClaimNoPrefix + cast(p.ICardsID as varchar) as iCardsID, p.Status, cu.LastName, cu.PostCode, cv.[ID] TransID,
isnull(sys.[description],'') as CardType, cv.cardvalue, p.wizardstage,
convert(char(10),cv.CreateDate,103)+' '+convert(char(5),cv.CreateDate,14) as CreateDate,
coalesce (e.FName + ' ' + e.SName, 'Administrator') as createdby,
convert(char(8),p.alteredDate,8) [time],
coalesce (e2.FName + ' ' + e2.SName, 'Administrator') as empname
from transactions cv join cards cd on cd.[ID]=cv.cardID
join customers cu on cu.[ID]=cd.customerID
join policies p on p.customerID=cu.[ID]
join card_companies cc on cc.[ID] = p.CompanyID
left join syslookup sys on sys.code=cd.cardtype and tablename='CardType'
left join ppd3.dbo.logon l on cv.createdby=l.UserID
left join ppd3.dbo.employees e on e.[Id] = l.UserFK
left join ppd3.dbo.logon l2 on p.alteredby=l2.UserID
left join ppd3.dbo.employees e2 on e2.[Id] = l2.UserFK
where cv.authrequirement=@level and authdate is null and wizardstage=4 and p.cancelreason is null
order by icardsid
GO
