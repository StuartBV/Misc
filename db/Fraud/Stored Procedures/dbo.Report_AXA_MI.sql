SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Report_AXA_MI]
@from varchar(10),
@to varchar(10)
AS

-- Has been superceded by fraud.dbo.[Report_MI_ByHub]
-- MH 16/09/09 
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

/*claims data received*/
select
	f.[FIN] [Our Reference],
	c.[InsuranceClaimNo] [axa Reference],
	convert(char(10),f.[CreateDate],103)+' '+convert(char(5),f.[CreateDate],14) [Date received],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [Date Closed],
	DATEDIFF(d,f.[CreateDate],coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.description Status,
	ppd3.dbo.ClaimCategoryConCat (c.OriginClaimID) [Commodities Affected],
	c.CauseofClaim [Peril],
	isnull(f.reasonclosed,'') [Closure Type],
	sys2.description [Evaluation],
	cp.Initial_Reserve [Savings Achieved]
from claims c
join fraud f on f.claimid=c.claimid
join customers cu on cu.[ID]=c.[CustID]
LEFT join [ClaimProperties] cp on cp.claimid=c.claimid
LEFT join [sysLookup] sys on sys.tablename='FraudStatus' and sys.code=f.status
LEFT join [sysLookup] sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
where f.CreateDate BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
order by f.fin


/* claims data closed */
select
	f.[FIN] [Our Reference],
	c.[InsuranceClaimNo] [axa Reference],
	convert(char(10),f.[CreateDate],103)+' '+convert(char(5),f.[CreateDate],14) [Date received],
	convert(char(10),f.[DateClosed],103)+' '+convert(char(5),f.[DateClosed],14) [Date Closed],
	DATEDIFF(d,f.[CreateDate],coalesce(f.[DateClosed],getdate())) [Total Lifecycle],
	sys.description Status,
	ppd3.dbo.ClaimCategoryConCat (c.OriginClaimID) [Commodities Affected],
	c.CauseofClaim [Peril],
	isnull(f.reasonclosed,'') [Closure Type],
	sys2.description [Evaluation],
	cp.Initial_Reserve [Savings Achieved]
from claims c
join fraud f on f.claimid=c.claimid
join customers cu on cu.[ID]=c.[CustID]
LEFT join [ClaimProperties] cp on cp.claimid=c.claimid
LEFT join [sysLookup] sys on sys.tablename='FraudStatus' and sys.code=f.status
LEFT join [sysLookup] sys2 on sys2.[TableName]='Risk' and sys2.code=f.risk
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
order by f.fin


/*claims received*/
select 1 [seq], 'Re-Zolve Received', count(*) [value]
from claims c
join fraud f on f.claimid=c.claimid
where f.CreateDate BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
union
/*claims closed*/
select 2 [seq], 'Re-Zolve Concluded', count(*) [value]
from claims c
join fraud f on f.claimid=c.claimid
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
union
/*claims outstanding*/
select 3 [seq], 'Re-Zolve Nil Settlement', count(*) [value]
from claims c
join fraud f on f.claimid=c.claimid
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
and f.reasonclosed in ('wlr','wps','nc','psi','ncc','rpi')
union
/*claims not settled*/
select 4 [seq], '% Re-Zolve Nil Settlement', round(cast(ppf as decimal(9,2))/cast(closed as decimal(9,2))*100,2) [value]
from (
select 
sum(case when f.reasonclosed in ('wlr','wps','nc','psi','ncc') then 1 else 0 end) [PPF],
count(*) [closed]
from claims c
join fraud f on f.claimid=c.claimid
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
) x
union
/*claims closed value*/
select 5 [seq], 'Total Claim Amount', sum(cp.Initial_Reserve) [value]
from claims c
join fraud f on f.claimid=c.claimid
join ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
union
/*claims closed and settled value*/
select 6 [seq], 'Total Settlement Cost', sum(cp.Initial_Reserve) [value]
from claims c
join fraud f on f.claimid=c.claimid
join ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
and f.reasonclosed not in ('wlr','wps','nc','psi','ncc','rpi')
union
/*claims closed and not settled value*/
select 7 [seq], 'Gross Savings', isnull(sum(cp.Initial_Reserve),0) [value]
from claims c
join fraud f on f.claimid=c.claimid
join ClaimProperties cp on f.ClaimID = cp.ClaimID
where f.DateClosed BETWEEN @fd AND @td
and f.originatingsys='PPD3'
and c.Channel='axa'
and c.AccountRef like 'axa%'
and f.reasonclosed in ('wlr','wps','nc','psi','ncc')

set transaction isolation level read committed


GO
