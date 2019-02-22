SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[genrep_fnol_JBI_axa_borderaux] 
@from varchar(10), 
@to varchar(10)

as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select p.PolicyNo,ltrim(c.Sname) claimant,c.ClientRefNo,convert(varchar(12),f.CreateDate,13) ScreenedAt,
convert(varchar(12),c.IncidentDate,13) IncidentDate,s.[description] cause,
convert(varchar(12),c.DateNotified,13) Notified,cp.amount,convert(varchar(12),cp.TransDate,13) transdate,
cp.ChequeNo,coalesce(c.Estimate,c.Reserve) [est/reserve],c.Total_amount,c.Total_Recovery,
convert(varchar(12),c.DateFinalised,13) finalised
from fnol_claims c 
join FNOL_Policy p on c.PolicyID=p.ID
join FNOL_ClaimPayments cp on c.ClaimID=cp.ClaimID
left join fraud.dbo.claims f on c.ClientRefNo=f.claimno
left join syslookup s on c.cause=s.code and s.tablename='fnol - cause'
left join syslookup s2 on c.CoverType=s2.code and s2.tablename='fnol - covertype'
left join syslookup s3 on c.[status]=s3.code and s3.tablename='fnol - statuscode'
where (c.DateFinalised is null or c.DateFinalised between @fd and @td)
and p.CoverType in ('F2JB','KC','KE') and left(c.ClientRefNo,2)='af'
order by c.claimid

GO
