SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[RedemptionSendDataStillOutstanding]
as
set transaction isolation level read uncommitted	
select 
	p.title + ' ' + p.lastname as [Customer Name],
	replace(p.address1 + ', ' + p.address2 + ', ' + p.town + ', ' + p.county + ', ' + p.postcode,' ,','') [Customer Address], 
	cast(isnull(CardNumber,0) as varchar) as [Card Number],
	cast(isnull(cardvalueoncompletion,0) as varchar) as [Card value],
	isnull(insuranceclaimno,'') as [Claim Number],
	isnull(insurancepolicyno,'') [Policy Number], 
	origoffice  as [Claim Office], 
	replace(s.address1 + ', ' + s.address2 + ', ' + s.town + ', ' + isnull(s.county,'') + ', ' + s.postcode,' ,','') as [Claim Office Address],
	'Refund in cancellation of the stated Options Card. Please allocate back to customer claim.' as [Details]
from redemptions r join policydetails p on p.iCardsID = 'CNU' + cast(r.iCardsID as varchar)
left join ppd3.dbo.sepsbranches s on s.AccountRef=p.SepSCode
group by CardNumber, p.title,p.lastname,p.address1, p.address2, p.town, p.county, p.postcode,
cardvalueoncompletion, p.insuranceclaimno, p.insurancepolicyno, 
p.origoffice, s.address1, s.address2, s.town, s.county, s.postcode




GO
