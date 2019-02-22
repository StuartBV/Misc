SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Report_WIP_Check]
@channel varchar(50)=''
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

select 'DATA' report_type, 'Details' report_title, f.FIN [Our ref],
	coalesce(c.[InsuranceClaimNo],c.ClaimNo) [Ins ref],
	convert(char(10),c.CreateDate,103)+' '+convert(char(5),c.CreateDate,14) [date Received],
	datediff(day, f.createdate, getdate()) as TotalDays,
	sys.[description] [Status], sys2.Description [Risk Indicator],
	case when f.Originatingsys='FNOL' and pc.claimid is null then fnol.dbo.ClaimCategoryConCat (c.OriginClaimID)
	else ppd3.dbo.ClaimCategoryConCat (pc.ClaimID)
	end	[Commodities Affected],	
	cast(cast(cp.[Amount_Claimed] as money) as varchar) LOL,
	case when cp.fraudindicator='99999' or f.OriginatingSys='fnol' then 'Manual'
		when cp.FraudIndicator<>'0' then 'SF'
		when bl.ID is not null then 'Business'
		else 'Unknown'
	end [trigger],
	case when gsm.ClaimID is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Jewellery Appt],
	case when coalesce(eng.claimid,comet.claimid) is not null and f.OriginatingSys='ppd3' then 'Yes' else '' end [Inspection Bkd],
	case when c.AccountRef = 'AXAREZ' then 'Intermediary (Personal Lines)' else 'Corporate Partners' end [Client Name]	
from claims c join fraud f on f.claimid=c.claimid
left join Bookings b  on f.bookingid = b.BookingID
join customers cu on cu.[ID]=c.CustID
left join ClaimProperties cp on cp.claimid=c.claimid
left join PPD3..ClaimProperties cps on cps.claimid=f.claimid
left join sysLookup sys on sys.tablename='FraudStatus' and sys.code=f.[status]
left join sysLookup sys2 on sys2.TableName='Risk' and sys2.code=f.risk
left join ppd3.dbo.sysLookup sys3 on sys3.TableName='FNOL - Cause' and sys3.code=c.Causeofclaim
left join ppd3.dbo.claims pc on c.OriginClaimID=pc.claimid
left join ppd3.dbo.ICE_BusinessRules_Log bl on bl.ClaimID=c.OriginClaimID and bl.RoleType=3
left join PPD3..View_AllClientBranches cb on c.AccountRef=cb.AccountRef
left join PPD3..InsuranceCos i on i.[id]=cb.clientID
left join PPD3..LossAdjusters l on l.[id]=cb.clientID
left join PPD3..InsuranceCos_AdditionalContact ac on ac.Id = cps.InsuranceCoContact
left join (select claimid,count(*) msg from ppd3.dbo.GoldsmithsMsgQOutgoing gs group by claimid) gsm on c.OriginClaimID=gsm.ClaimID
left join (select claimid,count(*) insp from ppd3.dbo.EngineerInspections ei group by claimid) eng on c.OriginClaimID=eng.ClaimID
left join (select claimid,count(*) insp from ppd3.dbo.CometInspections ci group by claimid) comet on c.OriginClaimID=comet.ClaimID
where f.DateClosed is null and c.channel=@channel
order by f.fin

select 'DATA' [report_type], 'Summary' [report_title], count(*) Outstanding,
sum(case when datediff(day, f.createdate, getdate())>30 then 1 else 0 end) [open 30+ Days],
sum(case when f.[status]=1 then 1 else 0 end) [Awaiting Appt],
sum(case when f.[status]=1 and datediff(day, x.transdate, getdate())>2 then 1 else 0 end) [Awaiting Appt 2+ Days]
from claims c join fraud f on f.claimid=c.claimid
left join (
	select fl.fin,max(fl.transdate) transdate
	from FraudLog fl join fraud fr on fr.fin=fl.fin and fr.DateClosed is null and fl.actiontaken=0
	group by fl.fin
) as x 
on  f.fin=x.fin
where f.DateClosed is null and c.Channel=@channel and isnull(f.ReasonClosed,'')<>'can' -- ignore cancelled claims

GO
