SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClaimsList] 
@isUpdate smallint=0
as
set nocount on
set transaction isolation level read uncommitted

select '<option value="' + f.FIN + '">' + cast(cl.ClaimNo as varchar) + ' - ' + 
case when isnull(coalesce(s1.[description],cl.CauseofClaim),'') like '%loss%' then 'Loss - ' 
	when isnull(coalesce(s1.[description],cl.CauseofClaim),'') like '%accident%' then 'A/D - '
	when isnull(coalesce(s1.[description],cl.CauseofClaim),'') like '%damage%' then 'A/D - '
	when isnull(coalesce(s1.[description],cl.CauseofClaim),'') like '%ad%' then 'A/D - '
	when isnull(coalesce(s1.[description],cl.CauseofClaim),'') like '%theft%' then 'Theft - '
	else ''
end + isnull(cu.lname,'') + ', ' + isnull(cu.Title,'') + ' ' + left(isnull(cu.fname,''),1) + '</option>' as list
from fraud f join claims cl  on f.ClaimID = cl.ClaimID
join Customers cu  on cu.ID=cl.CustID
left join ppd3.dbo.sysLookup s1  on s1.code=cl.CauseofClaim and s1.tablename='fnol - cause'
where f.DateClosed is null and f.[status]=1 and f.currenttier>1
order by cu.lname
GO
