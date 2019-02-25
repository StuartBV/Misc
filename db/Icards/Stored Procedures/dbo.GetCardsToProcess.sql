SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetCardsToProcess]
as
set nocount on

select s.code,s.description,s.extradescription,s.extracode,s.flags, count(distinct cv.[id]) actions
from dbo.Card_companies AS cc 
JOIN dbo.Policies AS p ON cc.ID = p.CompanyID 
JOIN dbo.Customers AS cu ON cu.iCardsID = p.ICardsID 
JOIN cards c on cu.id = c.customerid
join transactions cv on c.[id]=cv.cardid
join syslookup s on c.cardtype = s.code
where cv.status in (0,1)
and s.tablename='cardtype'
and p.wizardstage=4 AND p.cancelreason IS NULL
and (cv.authrequirement=0 or (cv.authrequirement>0 and cv.authdate is not null))
group by s.code,s.[description],s.extradescription,s.extracode,s.flags
GO
