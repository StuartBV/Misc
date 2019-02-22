SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Report_NU_Abacus_closed_MI]
@from varchar(10),
@to varchar(10)
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select distinct 
	f.[FIN] [Our Reference],
	c.[InsuranceClaimNo] [N.U. Reference],
	c.InsurancePolicyNo [Policy no],
	cu.title + ' ' + cu.[Fname] + ' ' + cu.lname [Insureds Name],
	convert(char(10),c.[CreateDate],103)+' '+convert(char(5),c.[CreateDate],14) [date received by iVal from NU],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [date Closed],
	datediff(d,c.[CreateDate],coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.[description] [Status],
	cp.[Amount_Claimed] [Validated limit of Liability],
	case when pc.claimid is null then fnol.dbo.ClaimCategoryConCat (c.OriginClaimID) 
	else ppd3.dbo.ClaimCategoryConCat (pc.ClaimID)
	end	[Commodities Affected],
	sys3.[description] [Peril Code],
	c.originatingoffice,
	isnull(f.reasonclosed,'') [type],
	isnull(b.bookedfor,'UnAssigned') agent,
	f.currenttier [Tier Achieved],
	sys2.[description] [Evaluation],
	cp.[Amount_Claimed]-isnull(c.excess,0) [Savings Achieved]
from claims c
join fraud f on f.claimid=c.claimid
left join Bookings b  on f.bookingid = b.BookingID
join customers cu on cu.[ID]=c.[CustID]
left join ClaimProperties cp on cp.claimid=c.claimid
left join fnol.dbo.fnol_claims fc on fc.claimid=c.originclaimid
left join sysLookup sys on sys.tablename='FraudStatus' and sys.code=f.[status]
left join sysLookup sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
left join ppd3.dbo.sysLookup sys3 on sys3.[TableName]='FNOL - Cause' and sys3.code=fc.Cause
left join ppd3.dbo.claims pc on c.OriginClaimID=pc.claimid and pc.Channel='af'
where f.DateClosed between @fd and @td and f.originatingsys='FNOL' and c.channel='abacus'
order by f.fin


GO
