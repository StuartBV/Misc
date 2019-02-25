SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCards_InvoiceRetrieve] as
--UTC--
set dateformat dmy
set transaction isolation level read uncommitted
select s.SePSShortCode as ClaimCentre, '001' as InstructorType, null as LossAdjusterCode, '' as LossAdjusterRef,
case when p.[type] = 'M' then p.cardvalue+isnull(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null then c.excess else null end,0)
else p.cardvalue end as UnitGross,
case when p.[type] = 'M' then p.cardvalue+isnull(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null then c.excess else null end,0)
else p.cardvalue end  as UnitNet, 0 as UnitVat, p.cardvalue as UnitInsurerCost, p.cardvalueid as InvoiceNumber,
convert(varchar(10),p.transdate,103) as InvoiceDate,
convert(varchar(10),p.transdate,103) as Agreementdate,
convert(varchar(10),p.transdate,103) as FirstActionDate,
case when p.[type] = 'M' then p.cardvalue+isnull(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null then c.excess else null end,0) 
	else p.cardvalue end as TotalGross,
case when p.[type] = 'M' then isnull(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null then c.excess else null end,0)
	else 0 end as excess,
case when p.[type] = 'M' then p.cardvalue+isnull(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null then c.excess else null end,0) 
	else p.cardvalue end as TotalNet,
0 as TotalVat, p.cardvalue as InvoiceTotal, p.title as PolicyholderTitle,
case when len(replace(p.firstname,'&','') + ' ' + p.lastname)>31 then left(replace(p.firstname,'&',''),(32-len(left(p.lastname,32)))) 
	else replace(p.firstname,'&','')
end as PolicyHolderFirstname,
replace(p.lastname, '&','') as PolicyHolderLastname,
p.address1 as Address1,
isnull(p.address2,'') as Address2,
isnull(p.town,'') as Town,
isnull(p.county,'') as County,
p.postcode as Postcode,
p.insurancepolicyno as PolicyNumber,
p.insuranceclaimno as ClaimNumber,
convert(varchar(10),p.createdate,113) as InstructionDate, 
isnull(convert(varchar(10),p.incidentdate,103),convert(varchar(12),dateadd(d,-3,p.createdate),103) ) as IncidentDate
from policydetails p 
left join ppd3.dbo.claims c  on p.ivalref = c.claimid
left join ppd3.dbo.sepsbranches s  on s.accountref=p.SepSCode
where p.[type] in ('B','M') -- B=Add Value to card M=new Card
and p.cardvalue > 0 -- Card has a value
and p.[status]=2 -- Has been uploaded
and p.invoiceddate is null -- Has NOT already been invoiced
and p.cancelreason is null -- has NOT been canclled
and wizardstage=4 -- Has all relevant info entered onto system
and s.SePSShortCode is not null

GO
