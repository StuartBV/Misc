SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Report_MI_ByHub]
@from varchar(10),
@to varchar(10),
@channel varchar(50)
AS
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime, @totalclaimamount money, @totalsettlementamount money

select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))


/*claims closed value*/
select @totalclaimamount=sum(cp.Initial_Reserve)
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
join fraud..ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims


/*claims closed and settled value*/
select @totalsettlementamount=sum(cp.Initial_Reserve) 
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
join fraud..ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
and f.reasonclosed in ('v','nfd','sba','ref')



/*claims data received*/
select 
	f.[FIN] [Our Reference],
	coalesce(c.[InsuranceClaimNo],c.ClaimNo) [Ins Reference],
	convert(char(10),c.[CreateDate],103)+' '+convert(char(5),c.[CreateDate],14) [Date received by iVal],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [Date Closed],
	DATEDIFF(d,c.[CreateDate],coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.description Status,
	coalesce(sys3.Description,c.CauseofClaim) [Peril Code],
	cp.[Amount_Claimed] [Validated Limit of Liability],
	CASE 
	when f.Originatingsys='FNOL' and pc.claimid IS NULL THEN fnol.dbo.ClaimCategoryConCat (c.OriginClaimID)
	ELSE ppd3.dbo.ClaimCategoryConCat (pc.ClaimID)
	end	[Commodities Affected],	
	c.originatingoffice,
	isnull(f.reasonclosed,'') [Type],
	ISNULL(b.bookedfor,'UnAssigned') agent,
	f.currenttier [Tier Achieved],
	--'' [Reason claim highlighted],
	sys2.description [Evaluation],
	cp.Initial_Reserve [Savings Achieved],
	case when cp.fraudindicator='99999' or f.OriginatingSys='fnol' then 'Manual'
		when cp.FraudIndicator<>'0' then 'SF'
		when bl.ID is not null then 'Business'
		else 'Unknown'
	end [Trigger],
	case when gsm.ClaimID is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Jewellery Appointed],
	case when coalesce(eng.claimid,comet.claimid) is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Inspection Booked]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
LEFT JOIN fraud..Bookings b  ON f.bookingid = b.BookingID
join fraud..customers cu on cu.[ID]=c.[CustID]
LEFT join fraud..[ClaimProperties] cp on cp.claimid=c.claimid
LEFT join fraud..[sysLookup] sys on sys.tablename='FraudStatus' and sys.code=f.status
LEFT join fraud..[sysLookup] sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
LEFT join ppd3..[sysLookup] sys3 on sys3.[TableName]='FNOL - Cause' and sys3.code=c.Causeofclaim
LEFT JOIN ppd3..claims pc ON c.OriginClaimID=pc.claimid
left join ppd3..ICE_BusinessRules_Log bl on bl.ClaimID=c.OriginClaimID and bl.RoleType=3
left join (select claimid,count(*) [msg] from ppd3..GoldsmithsMsgQOutgoing gs group by claimid) gsm on c.OriginClaimID=gsm.ClaimID
left join (select claimid,count(*) [insp] from ppd3..EngineerInspections ei group by claimid) eng on c.OriginClaimID=eng.ClaimID
left join (select claimid,count(*) [insp] from ppd3..CometInspections ci group by claimid) comet on c.OriginClaimID=comet.ClaimID
where f.CreateDate BETWEEN @fd AND @td
and c.Channel=@channel
and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims
order by f.fin


/* claims data closed */
select 
	f.[FIN] [Our Reference],
	coalesce(c.[InsuranceClaimNo],c.ClaimNo) [Ins Reference],
	convert(char(10),c.[CreateDate],103)+' '+convert(char(5),c.[CreateDate],14) [Date received by iVal],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [Date Closed],
	DATEDIFF(d,c.[CreateDate],coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.description Status,
	coalesce(sys3.Description,c.CauseofClaim) [Peril Code],
	cp.[Amount_Claimed] [Validated Limit of Liability],
	CASE 
	when f.Originatingsys='FNOL' and pc.claimid IS NULL THEN fnol.dbo.ClaimCategoryConCat (c.OriginClaimID)
	ELSE ppd3.dbo.ClaimCategoryConCat (pc.ClaimID)
	end	[Commodities Affected],	
	c.originatingoffice,
	isnull(f.reasonclosed,'') [Type],
	ISNULL(b.bookedfor,'UnAssigned') agent,
	f.currenttier [Tier Achieved],
	--'' [Reason claim highlighted],
	sys2.description [Evaluation],
	cp.Initial_Reserve [Savings Achieved],
	case when cp.fraudindicator='99999' or f.OriginatingSys='fnol' then 'Manual'
		when cp.FraudIndicator<>'0' then 'SF'
		when bl.ID is not null then 'Business'
		else 'Unknown'
	end [Trigger],
	case when gsm.ClaimID is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Jewellery Appointed],
	case when coalesce(eng.claimid,comet.claimid) is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Inspection Booked]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
LEFT JOIN fraud..Bookings b  ON f.bookingid = b.BookingID
join fraud..customers cu on cu.[ID]=c.[CustID]
LEFT join fraud..[ClaimProperties] cp on cp.claimid=c.claimid
LEFT join fraud..[sysLookup] sys on sys.tablename='FraudStatus' and sys.code=f.status
LEFT join fraud..[sysLookup] sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
LEFT join ppd3..[sysLookup] sys3 on sys3.[TableName]='FNOL - Cause' and sys3.code=c.Causeofclaim
LEFT JOIN ppd3..claims pc ON c.OriginClaimID=pc.claimid
left join ppd3..ICE_BusinessRules_Log bl on bl.ClaimID=c.OriginClaimID and bl.RoleType=3
left join (select claimid,count(*) [msg] from ppd3..GoldsmithsMsgQOutgoing gs group by claimid) gsm on c.OriginClaimID=gsm.ClaimID
left join (select claimid,count(*) [insp] from ppd3..EngineerInspections ei group by claimid) eng on c.OriginClaimID=eng.ClaimID
left join (select claimid,count(*) [insp] from ppd3..CometInspections ci group by claimid) comet on c.OriginClaimID=comet.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims
order by f.fin


/*claims received*/
select 1 [seq], 'Claims Received', count(*) [value]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
where f.CreateDate BETWEEN @fd AND @td
and c.Channel=@channel
and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims
union
/*claims closed*/
select 2 [seq], 'Claims Closed', count(*) [value]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims
union
/*claims outstanding*/
select 3 [seq], 'Claims Outstanding', count(*) [value]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
where f.DateClosed is null
and c.Channel=@channel
and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims
union
/*claims closed as nil*/
select 4 [seq], 'Claims Nil Settlement', count(*) [value]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
and f.ReasonClosed in ('ef','ppf','wps','wlr','insw','insp','insc','rpi','psi','nc','ncc')
union
/*claims not settled*/
select 5 [seq], '% Claims Nil Settlement', round(cast(ppf as decimal(9,2))/cast(closed as decimal(9,2))*100,2) [value]
from (
select 
sum(case when f.reasonclosed in ('ef','ppf','wps','wlr','insw','insp','insc','rpi','psi','nc','ncc') then 1 else 0 end) [PPF],
count(*) [closed]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
) x
union
/*claims closed value*/
select 6 [seq], 'Total Claim Amount', @totalclaimamount [value]
union
/*claims closed and settled value*/
select 7 [seq], 'Total Settlement Amount', @totalsettlementamount [value]
union
/*claims closed and not settled value*/
select 8 [seq], 'Gross Savings', @totalclaimamount-@totalsettlementamount [value]
union
/*claims closed and settled value*/
select 9 [seq], 'PPF Savings', sum(cp.Initial_Reserve) 
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
join ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and c.Channel=@channel
and f.reasonclosed in ('ppf','ef')

set transaction isolation level read committed


GO
