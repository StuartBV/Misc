SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[genrep_fnol_Abacus_complaints] 
@from varchar(10), 
@to varchar(10)
as
set nocount on
set dateformat dmy

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime) + '00:00', @td=cast(@to as datetime) + '23:59:59'

select 
	c.ClientRefNo [Ref No],
	'' [Rptd as closed to FSA],
	'34' [Prod Code],
	'' Cat,
	'' [No Days],
	'' [Date Closed],
	'' [Closed within 2 Days],
	'' [Closed within 5 Days],
	'' [Closed within 4 Weeks],
	'' [Closed within 8 Weeks],
	'' [Closed after 8 Weeks],
	convert(varchar(12),n.CreateDate,13) [Date Rec'd'],
	c.Sname Surname,
	left(c.Fname,1) Inits,
	c.Regiment Unit,
	p.PolicyNo [Policy Number],
	n.CreatedBy Advisor,
	convert(varchar(12),p.InceptionDate,13) [Policy start Date],
	Fnol.dbo.ClaimCategoryConCat(c.ClaimID) [Items claimed for],
	sl.[Description] [Section claiming Under],
	convert(varchar(12),c.IncidentDate,13) [Claim Date],
	n.Note [Reason for Complaint],
	'' [Ack Sent],
	'' [Final Resp],
	'' Resolved,
	'' [Complaint Upheld/Declined],
	'' [Redress/Compensation]
from FNOL_Claims c 
join FNOL_Policy p on c.PolicyID=p.ID
join FNOL_Notes n on n.ClaimID=c.ClaimID and n.NoteReason=20
join sysLookup sl on sl.Code=c.Cause and sl.TableName='FNOL - Cause'
where n.CreateDate between @fd and @td and p.Client='abacus'
order by c.ClaimID

-- This is interesting. The above query exists in PPD3 under the same name as the report below.
-- The query only touches tables in the FNOL DB so that's where it belongs.
-- I am moving it from PPD3 to Fnol and turning the proc in PPD3 into a wrapper to call it in Fnol.
-- Seems very odd that there is a different report with exactly the same name.
-- Therefore including the other report here in case it needs referring to.

/*
CREATE procedure [dbo].[genrep_fnol_Abacus_complaints] 
@from varchar(10), 
@to varchar(10)
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select c.clientrefno [ref no],convert(varchar(12),n.createdate,13) [trans date],c.sname [surname],left(c.fname,1) [init],
c.regiment,p.policyno,n.CreatedBy [handler],convert(varchar(12),p.inceptiondate,13) [inc date],s1.[description] [cause],convert(varchar(12),c.IncidentDate,13) [inc date],n.Note [desc]
from fnol_claims c join FNOL_Policy p  on c.PolicyID=p.ID
join FNOL_Notes n on n.claimid=c.claimid and n.NoteReason=20 and left(c.ClientRefNo,2)='af'
join syslookup s1 on c.cause=s1.code and s1.tablename='FNOL - Cause'
where n.createdate between @fd and @td
and p.CoverType not in ('F2JB','KC','KE')
order by c.claimid
*/
GO
