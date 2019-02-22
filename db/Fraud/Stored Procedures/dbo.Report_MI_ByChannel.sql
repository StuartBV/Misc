SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Report_MI_ByChannel]

@from varchar(10),
@to varchar(10),
@channel varchar(50)=''
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime, @totalclaimamount money, @totalclaimvalue money, @totalnfdvalue money,
@totalsbivalue money, @totalrtivalue money, @totalppfvalue money, @totalinsvalue money

select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

/*claims closed value*/
select @totalclaimamount=sum(cp.Initial_Reserve)
from claims c join fraud f on f.claimid=c.claimid
join ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed between @fd and @td and c.Channel=@channel
and isnull(f.ReasonClosed,'')!='can' -- ignore cancelled claims

/*claims closed and settled value*/
select 
--@totalclaimvalue=sum(cp.Initial_Reserve) ,
@totalnfdvalue=sum(case when f.reasonclosed='nfd' then cp.Initial_Reserve else 0 end),
@totalsbivalue=sum(case when f.reasonclosed='sbi' then cp.Initial_Reserve else 0 end),
@totalrtivalue=sum(case when f.reasonclosed='rti' then cp.Initial_Reserve else 0 end),
@totalppfvalue=sum(case when f.reasonclosed in ('ppfw','ppfr','ef','efw') then cp.Initial_Reserve else 0 end),
@totalinsvalue=sum(case when f.reasonclosed in ('insp','insw','insc') then cp.Initial_Reserve else 0 end)
from claims c join fraud f on f.claimid=c.claimid
join ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed between @fd and @td and c.Channel=@channel
and f.reasonclosed in ('nfd','sbi','rti','ppfw','ppfr','efr','efw','insp','insw','insc')

/*claims data received*/
if exists(select * from claims c join fraud f on f.claimid=c.claimid 
		where f.CreateDate between @fd and @td
		and c.Channel=@channel and isnull(f.ReasonClosed,'')!='can')
begin
	select distinct 'DATA' report_type, 'Claims Received Details' report_title, f.[FIN] [Our Reference], c.originclaimid [CMS ref], c.accountref [CMS Account ref],
		coalesce(c.[InsuranceClaimNo],c.ClaimNo) [Ins Reference], convert(char(10),c.createdate,103)+' '+convert(char(5),c.createdate,14) [date received by iVal],
		convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [date Closed],
		datediff(d,c.createdate,coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
		sys.[description] [status], coalesce(sys3.[description],c.CauseofClaim) [Peril Code],
		cp.Amount_Claimed [Validated limit of Liability],
		case when f.Originatingsys='FNOL' 
			then fnol.dbo.ClaimCategoryConCat (c.OriginClaimID) else ppd3.dbo.ClaimCategoryConCat (pc.ClaimID)
		end	[Commodities Affected],	
		c.originatingoffice, isnull(f.reasonclosed,'') [type],
		case when left(f.ReasonClosed_SubCategory,1)='w' then isnull(f.ReasonClosed_SubCategory,'') else '' end [Withdrawal Stage],
		case when left(f.ReasonClosed_SubCategory,1)='w' then '' else isnull(f.ReasonClosed_SubCategory,'') end [Reason],
		isnull(b.bookedfor,'UnAssigned') agent, f.currenttier [Tier Achieved], sys2.[description] Evaluation,
		cp.Initial_Reserve [Savings Achieved],
		case when cp.fraudindicator='99999' or f.OriginatingSys='fnol' then 'Manual'
			when cp.FraudIndicator<>'0' then 'SF'
			when bl.ID is not null then 'Business'
			else 'Unknown'
		end [trigger],
		case when gsm.ClaimID is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Jewellery Appointed],
		case when coalesce(eng.claimid,comet.claimid) is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Inspection Booked],
		case when c.AccountRef = 'AXAREZ' then 'Intermediary (Personal Lines)' else 'Corporate Partners' end [Client Name]
	from claims c join fraud f on f.claimid=c.claimid
	left join Bookings b on f.bookingid = b.BookingID
	left join customers cu on cu.[ID]=c.[CustID]
	left join ClaimProperties cp on cp.claimid=c.claimid
	left join syslookup sys on sys.tablename='FraudStatus' and sys.code=f.status
	left join syslookup sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
	left join ppd3.dbo.syslookup sys3 on sys3.[TableName]='FNOL - Cause' and sys3.code=c.Causeofclaim
	left join ppd3.dbo.claims pc on c.OriginClaimID=pc.claimid and f.OriginatingSys='PPD3'
	left join ppd3.dbo.ICE_BusinessRules_Log bl on bl.ClaimID=c.OriginClaimID and bl.RoleType=3
	left join PPD3..ClaimProperties cps on cps.claimid=f.claimid
	left join PPD3..View_AllClientBranches cb on c.AccountRef=cb.AccountRef
	left join PPD3..InsuranceCos i on i.[id]=cb.clientID
	left join PPD3..LossAdjusters l on l.[id]=cb.clientID
	left join PPD3..InsuranceCos_AdditionalContact ac on ac.Id = cps.InsuranceCoContact
	left join (select claimid,count(*) msg from ppd3.dbo.GoldsmithsMsgQOutgoing gs group by claimid) gsm on c.OriginClaimID=gsm.ClaimID
	left join (select claimid,count(*) insp from ppd3.dbo.EngineerInspections ei group by claimid) eng on c.OriginClaimID=eng.ClaimID
	left join (select claimid,count(*) insp from ppd3.dbo.CometInspections ci group by claimid) comet on c.OriginClaimID=comet.ClaimID
	where f.CreateDate between @fd and @td
	and c.Channel=@channel
	and isnull(f.ReasonClosed,'')!='can' -- ignore cancelled claims
	order by f.fin
end 
else
begin 
	select 'DATA' as report_type, 'Claims Received Details' as report_title, '' as [Our Reference], '' as [CMS ref], '' as [CMS Account ref],
	'' as [Ins Reference], '' as [date received by iVal], '' as [date Closed], '' as [Total Lifecycle status], '' as [Peril Code],
	'' as [Validated limit of Liability], '' as [Commodities Affected], '' as [originatingoffice], '' as [type], '' as [Withdrawal Stage],
	'' as [Reason], '' as [agent], '' as [Tier Achieved Evaluation], '' as [Savings Achieved], '' as [trigger], '' as [Jewellery Appointed],
	'' as [Inspection Booked]
end

/* claims data closed */
select distinct 'DATA' report_type, 'Claims Closed Details' report_title, f.[FIN] [Our Reference], c.originclaimid [CMS ref], c.accountref [CMS Account ref],
	coalesce(c.[InsuranceClaimNo],c.ClaimNo) [Ins Reference],convert(char(10),c.createdate,103)+' '+convert(char(5),c.createdate,14) [date received by iVal],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [date Closed], datediff(d,c.createdate,coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.[description] [status], coalesce(sys3.[description],c.CauseofClaim) [Peril Code], cp.Amount_Claimed [Validated limit of Liability],
	case 
		when f.Originatingsys='FNOL' and pc.claimid is null then fnol.dbo.ClaimCategoryConCat (c.OriginClaimID)
		else ppd3.dbo.ClaimCategoryConCat (pc.ClaimID)
	end	[Commodities Affected],	
	c.originatingoffice, isnull(f.reasonclosed,'') [type],
	case when left(f.ReasonClosed_SubCategory,1)='w' then isnull(f.ReasonClosed_SubCategory,'') else '' end [Withdrawal Stage],
	case when left(f.ReasonClosed_SubCategory,1)='w' then '' else isnull(f.ReasonClosed_SubCategory,'') end [Reason],
	isnull(b.bookedfor,'UnAssigned') agent, f.currenttier [Tier Achieved], sys2.[description] Evaluation, cp.Initial_Reserve [Savings Achieved],
	case when cp.fraudindicator='99999' or f.OriginatingSys='fnol' then 'Manual'
		when cp.FraudIndicator<>'0' then 'SF'
		when bl.ID is not null then 'Business'
		else 'Unknown'
	end [trigger],
	case when gsm.ClaimID is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Jewellery Appointed],
	case when coalesce(eng.claimid,comet.claimid) is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Inspection Booked],
	case when c.AccountRef = 'AXAREZ' then 'Intermediary (Personal Lines)' else 'Corporate Partners' end [Client Name]
from claims c join fraud f on f.claimid=c.claimid
left join Bookings b on f.bookingid = b.BookingID
join customers cu on cu.[ID]=c.[CustID]
left join [ClaimProperties] cp on cp.claimid=c.claimid
left join syslookup sys on sys.tablename='FraudStatus' and sys.code=f.status
left join syslookup sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
left join ppd3.dbo.syslookup sys3 on sys3.[TableName]='FNOL - Cause' and sys3.code=c.Causeofclaim
left join ppd3.dbo.claims pc on c.OriginClaimID=pc.claimid and f.OriginatingSys='PPD3'
left join ppd3.dbo.ICE_BusinessRules_Log bl on bl.ClaimID=c.OriginClaimID and bl.RoleType=3
left join PPD3..ClaimProperties cps on cps.claimid=f.claimid
left join PPD3..View_AllClientBranches cb on c.AccountRef=cb.AccountRef
left join PPD3..InsuranceCos i on i.[id]=cb.clientID
left join PPD3..LossAdjusters l on l.[id]=cb.clientID
left join PPD3..InsuranceCos_AdditionalContact ac on ac.Id = cps.InsuranceCoContact
left join (select claimid,count(*) [msg] from ppd3.dbo.GoldsmithsMsgQOutgoing gs group by claimid) gsm on c.OriginClaimID=gsm.ClaimID
left join (select claimid,count(*) [insp] from ppd3.dbo.EngineerInspections ei group by claimid) eng on c.OriginClaimID=eng.ClaimID
left join (select claimid,count(*) [insp] from ppd3.dbo.CometInspections ci group by claimid) comet on c.OriginClaimID=comet.ClaimID
where f.DateClosed between @fd and @td
and c.Channel=@channel
and isnull(f.ReasonClosed,'')!='can' -- ignore cancelled claims
order by f.fin

/*claims received*/
select 'DATA' [report_type], 'Claim Summary Details' report_title, title, [value] from (
	select 1 seq, 'Claims Received' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.CreateDate between @fd and @td
	and c.Channel=@channel and isnull(f.ReasonClosed,'')<>'can'
	union
	/*claims closed*/
	select 2 seq, 'Claims Closed' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.DateClosed between @fd and @td
	and c.Channel=@channel and isnull(f.ReasonClosed,'')<>'can'
	union
	/*claims outstanding*/
	select 3 seq, 'Claims Outstanding' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.DateClosed is null
	and c.Channel=@channel and isnull(f.ReasonClosed,'')<>'can'
	union
	/*claims closed as Ef*/
	select 4 seq, 'Claims Closed as EF' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.DateClosed between @fd and @td
	and c.Channel=@channel and f.ReasonClosed in ('efw','efr')
	union
	/*claims closed as PPF*/
	select 5 seq, 'Claims Closed as PPF' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.DateClosed between @fd and @td
	and c.Channel=@channel and f.ReasonClosed in ('ppfw','ppfr')
	union
	/*claims closed as INS*/
	select 6 seq, 'Claims Closed as INS' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.DateClosed between @fd and @td
	and c.Channel=@channel and f.ReasonClosed in ('insw','insp','insc')
	union
	/*claims closed as nil*/
	select 7 seq, 'Claims Nil Settlement' title, count(*) [value]
	from claims c join fraud f on f.claimid=c.claimid
	where f.DateClosed between @fd and @td
	and c.Channel=@channel and f.ReasonClosed in ('efw','efr','ppfw','ppfr','insw','insp','insc')
	union
	/*claims not settled*/
	select 8 seq, '% Claims Nil Settlement' title, round(cast(ppf as decimal(9,2))/cast(closed as decimal(9,2))*100,2) [value]
	from (
		select sum(case when f.reasonclosed in ('efw','efr','ppfw','ppfr','insw','insp','insc') then 1 else 0 end) [PPF], count(*) [closed]
		from claims c join fraud f on f.claimid=c.claimid
		where f.DateClosed between @fd and @td
		and c.Channel=@channel and isnull(f.ReasonClosed,'')<>'can'
	) z
	union
	/*claims closed value*/
	select 9 seq, 'Total Closed Amount' title, @totalclaimamount [value]
	union
	/*claims closed and settled value*/
	select 10 seq, 'Total NFD Amount' title, @totalnfdvalue [value]
	union
	/*claims closed and not settled value*/
	select 11 seq, 'Total SBI Amount' title, @totalsbivalue [value]
	union
	/*claims closed and not settled value*/
	select 12 seq, 'Total RTI Amount' title, @totalrtivalue [value]
	union
	/*claims closed and not settled value*/
	select 13 seq, 'Total PPF Amount' title, @totalppfvalue [value]
	union
	/*claims closed and not settled value*/
	select 14 seq, 'Total INS Amount' title, @totalinsvalue [value]

)x order by x.seq

GO
