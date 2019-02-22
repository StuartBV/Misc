SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClaimDetails] 
@ClaimID varchar(50)
as
set nocount on
set transaction isolation level read uncommitted

select cl.ClaimID,
isnull(P.PolicyNo,'') PolicyNo,
isnull(co.Company,'') Company,
isnull(cl.ClientRefNo,'') ClientRefNo,
convert(varchar(12),cl.IncidentDate,103) IncidentDate,
isnull(cl.AccountYear,'') AccountYear,
isnull(cl.ClaimHandler,'') ClaimHandler,
isnull(cl.Title,'') title,
isnull(cl.Fname,'') Fname,
isnull(cl.Sname,'') Sname,
isnull(cl.Address1,'') Address1,
isnull(cl.Address2,'') Address2,
isnull(cl.City,'') City,
isnull(cl.County,'') County,
isnull(cl.Postcode,'') Postcode,
isnull(cl.Country,'') Country,
isnull(cl.Hphone,'') Hphone,
isnull(cl.Wphone,'') Wphone,
isnull(cl.Mphone,'') Mphone,
isnull(cl.Email,'') Email,
isnull(cl.[description],'') [description],
convert(varchar(12),cl.DOB,103) DOB,
isnull(cl.CountryOfLoss,'') countryOfLoss,
convert(varchar(12),cl.DateFinalised,103) DateFinalised,
convert(varchar(12),cl.DateReopened,103) DateReopened,
isnull(LaptopInvolved,'') LaptopInvolved,
isnull(PoliceStation,'') PoliceStation,
isnull(PoliceAddress,'') PoliceAddress,
isnull(CrimeRef,'') CrimeRef,
convert(varchar(12),DateNotified,103) DateNotified,
isnull(cl.[description],'') [description],
isnull(cl.serviceno,'') ServiceNo,
isnull(cause.[description],'') Cause,
isnull(maritalstatus.[description],'') maritalstatus,
isnull(rank.[description],'') rank,
isnull(left(regiment.[description],36),'') regiment,
isnull([status].[description],'') [status],
isnull(outcome.[description],'') Outcome,
isnull(cover.[description],'') covertype,
isnull(cl.c_Address1,'') c_Address1,
isnull(cl.c_Address2,'') c_Address2,
isnull(cl.c_City,'') c_City,
isnull(cl.c_County,'') c_County,
isnull(cl.c_Postcode,'') c_Postcode,
isnull(cl.c_Country,'') c_Country,
isnull(cl.contactname2,'') contactname2,
isnull(cl.contactphone2,'') contactphone2,
isnull(la.[description],'') LossAdjuster,
isnull(x.IsPendingRecovery,0) IsPendingRecovery,
isnull(cl.CmsRef,0) CmsRef
from FNOL_Claims cl join FNOL_Policy P on cl.PolicyID=p.ID and cl.claimid=@ClaimID
join fnol_companies co on p.companyid=co.id 
left join syslookup cause on cl.cause=cause.code and cause.tablename='fnol - cause' 
left join syslookup maritalstatus on cl.maritalstatus=maritalstatus.code and maritalstatus.tablename='fnol - maritalstatus' 
left join syslookup [rank] on cl.[rank]=[rank].code and [rank].tablename='fnol - militaryrank' 
left join syslookup regiment on cl.regiment=regiment.code and regiment.tablename='fnol - militaryregiment' 
left join syslookup [status] on cl.[status]=[status].code and [status].tablename='fnol - [status]code' 
left join syslookup cover on cl.covertype=cover.code and cover.tablename='fnol - covertype'
left join syslookup outcome on cl.outcome=outcome.code and outcome.tablename='fnol - outcome'
left join syslookup la on cl.lossadjuster=la.code and la.tablename='fnol - lossadjuster'
left join (
	select r.claimid,count(*) [IsPendingRecovery] 
	from dbo.Reminders r 
	where r.Claimid=@ClaimID 
	and r.Type='penrec'
	and DateCompleted is null
	group by r.claimid
) x on x.claimid=cl.ClaimID

select 1 [seq], 'Select' [text],'' [value]
union all
select 2 [seq], [description] [text], Extradescription [value]
from syslookup
where tablename='fnol - letters'
order by seq,[text]

GO
