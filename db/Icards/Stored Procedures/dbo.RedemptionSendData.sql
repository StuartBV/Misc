SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[RedemptionSendData]
@headers tinyint=0,
@RedemptionID int
as
set transaction isolation level read uncommitted
select 'Customer Name','Customer Address','Card Number','Card Value','Claim Number','Policy Number','Claim Office','Claim Office Address','Details'
union all 
select 
	p.title + ' ' + p.lastname as [Customer Name],
	replace(p.address1 + ', ' + p.address2 + ', ' + p.town + ', ' + p.county + ', ' + p.postcode,' ,','') [Customer Address], 

	'''**************' + right(cast(isnull(CardNumber,0) as varchar),4) as [Card Number],
	cast(isnull(cardvalueoncompletion,0) as varchar) as [Card value],
	'''' + isnull(insuranceclaimno,'') as [Claim Number],
	'''' + isnull(insurancepolicyno,'') [Policy Number], 
	origoffice  as [Claim Office], 
	replace(s.address1 + ', ' + isnull(s.address2,'') + ', ' + s.town + ', ' + isnull(s.county,'') + ', ' + s.postcode,' ,','') as [Claim Office Address],
	'Refund in cancellation of the stated Options Card. Please allocate back to customer claim.' as [Details]
	from redemptions r join policydetails p on p.iCardsID = 'CNU' + cast(r.iCardsID as varchar)
	left join ppd3.dbo.sepsbranches s on s.AccountRef=p.SepSCode
	where r.ID=@RedemptionID 
	group by CardNumber, p.title,p.lastname,p.address1, p.address2, p.town, p.county, p.postcode,
	 cardvalueoncompletion, p.insuranceclaimno, p.insurancepolicyno, 
	p.origoffice, s.address1, s.address2, s.town, s.county, s.postcode


GO
