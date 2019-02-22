SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Report_NU_Received_MI]
@from varchar(10),
@to varchar(10)
AS
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select  
	f.[FIN] [Our Reference],
	c.[InsuranceClaimNo] [N.U. Reference],
	cu.title + ' ' + cu.[Fname] + ' ' + cu.lname [Insureds Name],
	convert(char(10),c.[CreateDate],103)+' '+convert(char(5),c.[CreateDate],14) [Date received by iVal from NU],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [Date Closed],
	DATEDIFF(d,c.[CreateDate],coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.description Status,
	cp.[Amount_Claimed] [Validated Limit of Liability],
	ppd3.dbo.ClaimCategoryConCat (c.OriginClaimID) [Commodities Affected],
	c.originatingoffice,
	isnull(f.reasonclosed,'') [Type],
	'' [Reason claim highlighted],
	f.currenttier [Tier Achieved],
	sys2.description [Evaluation],
	cp.[Amount_Claimed]-ISNULL(c.excess,0) [Savings Achieved],
	case
		when bl.ID is not null and isnull(cp.FraudIndicator,'') in ('','0') then 'Trigger' 
		when bl.ID is not null and isnull(cp.FraudIndicator,'') not in ('','0') then 'Trigger/SF' 
		when bl.ID is null and f.Manual=0 and isnull(cp.FraudIndicator,'') not in ('','0') then 'SF'
		when bl.ID is null and f.Manual=1 and isnull(cp.FraudIndicator,'') not in ('','0') then 'Manual/SF'
		when bl.ID is null and f.Manual=1 and isnull(cp.FraudIndicator,'') in ('','0') then 'Manual'
		else 'Unknown'
	end [ReasonLocked],
	case when gs.ClaimID is not null then 'Yes' else '' end [Jewellery Appointed],
	case when coalesce(eng.claimid,comet.claimid) is not null then 'Yes' else '' end [Inspection Booked]
from fraud..claims c
join fraud..fraud f on f.claimid=c.claimid
join fraud..customers cu on cu.[ID]=c.[CustID]
LEFT join fraud..[ClaimProperties] cp on cp.claimid=c.claimid
LEFT join fraud..[sysLookup] sys on sys.tablename='FraudStatus' and sys.code=f.status
LEFT join fraud..[sysLookup] sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
left join ppd3..ICE_BusinessRules_Log bl on bl.ClaimID=c.OriginClaimID and bl.RoleType=3
left join ppd3..GoldsmithsMsgQOutgoing gs on c.OriginClaimID=gs.ClaimID
left join (select claimid,count(*) [insp] from ppd3..EngineerInspections ei group by claimid) eng on c.OriginClaimID=eng.ClaimID
left join (select claimid,count(*) [insp] from ppd3..CometInspections ci group by claimid) comet on c.OriginClaimID=comet.ClaimID
where c.channel IN ('ival','nuibrad')
AND f.CreateDate BETWEEN @fd AND @td
and f.originatingsys='PPD3'
order by f.fin

set transaction isolation level read committed

GO
