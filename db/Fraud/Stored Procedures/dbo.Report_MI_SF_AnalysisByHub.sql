SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

CREATE PROCEDURE [dbo].[Report_MI_SF_AnalysisByHub]
@from varchar(10),
@to varchar(10),
@channel varchar(50)
AS
set nocount on

set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime

select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select 
	c.claimid [Our Reference],
	c.channel [hub],
	x.allowedrrp [value],
	c.[InsuranceClaimNo] [Ins Reference],
	c.CauseofClaim [Peril Code],
	ppd3.dbo.ClaimCategoryConCat (c.ClaimID) [Commodities Affected],	
	'SF'+cast(isnull(cp.FraudIndicator,'0') as varchar) [SF],
	case when f.claimid is not null then 'Locked' else '' end [Locked]	
from ppd3.dbo.claims c
join ppd3.dbo.[ClaimProperties] cp on cp.claimid=c.claimid
join (
	select cpr.claimid, sum(cpr.[value]) [allowedrrp]
	from ppd3.dbo.[ICE_ClaimProducts] cpr (nolock) 
	join ppd3.dbo.[ICE_Categories] cat (nolock) on cat.id=cpr.catid 
	group by cpr.ClaimID
)x on x.claimid=c.claimid
left join fraud.dbo.claims f on f.OriginClaimID=c.claimid
left join ppd3.dbo.ICE_BusinessRules_Log bl on bl.ClaimID=c.ClaimID and bl.RoleType=3
where c.CreateDate BETWEEN @fd AND @td
and c.Channel=@channel
and isnull(cp.FraudIndicator,'') not in ('','0')

set transaction isolation level read committed















GO
