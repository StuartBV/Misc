SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetLetterDetails]
@claimref varchar(50)
as 
set nocount on
declare @d datetime=getdate()

select
c.clientrefno [PHrefno], 
p.PolicyNo [PHpolicyno],
p.Client [PHscheme],
convert(varchar(12),c.IncidentDate,113) [PHincidentdate],
c.Title [PHtitle],
ltrim(isnull(c.Fname,'')+' '+isnull(c.Sname,'')) [PHname],
isnull(c.Sname,'') [PHsurname],
c.Address1 [PHaddress1],
c.Address2 [PHaddress2],
c.City [PHcity],
c.County [PHcounty],
c.Postcode [PHpostcode],
c.Hphone [PHhomephone],
c.Wphone [PHworkphone],
c.Mphone [PHmobile],
c.Email [PHemail],
c.ServiceNo [PHserviceno],
isnull(s3.[description],'') [PHrank],
isnull(s4.[description],'') [PHregiment],
s5.[description] [PHstatus],
convert(varchar(12),c.DOB,113) [PHbirthdate],
convert(varchar(12),p.InceptionDate,113) [PHinceptiondate],
convert(varchar(12),c.CreatedDate,113) [PHdatenotified],
c.[Description] [PHclaimdetails],
s.[Description] [PHcauseofclaim],
s2.[Description] [PHcovertype],
s1.[description] [PHclient],
c.ClaimHandler [PHhandler],
c.Contactname2 [PHsecondcontact],
c.ContactPhone2 [PHsecondphoneno],
x.[Contact Lenses] [PHcontactlenseslimit],
x.Contents [PHcontentslimit],
x.[Desktop PC] [PHpclimit],
x.Laptop [PHlaptoplimit],
x.[Military Kit] [PHmilitarykitlimit],
x.[Pedal Cycles] [PHcycleslimit],
x.[Personal Possessions] [PHpossessionslimit],
x.Spectacles [PHspectacleslimit],
x.[Tenants Liability] [PHtennantslimit],
od.TeamName [PHofficename],
od.Address1 [PHofficeroad],
od.Town [PHofficetown],
od.County [PHofficecounty],
od.Postcode [PHofficepostcode],
od.PhoneNumber [PHofficephoneno],
od.FaxNumber [PHofficefaxno],
od.Email [PHofficeemail],
isnull(s6.[description],'Unknown') [PHperil],
c.PoliceAddress [PHpoliceaddress],
convert(varchar(12),c.DateNotified,113) [PHpolicenotified],
c.CrimeRef [PHcrimeref],
c.Reserve [PHreserve],
case when p.client='abacus' then 'If the item(s) in question are specified on your policy, in particular valuables over £500, Laptops and Pedal Cycles, please ensure you contact Abacus Ltd Head Office on 0845 2571515 to review the sums insured.' else '' end [PHabacusitemnote],
cast(datename(weekday,@d) + ', ' + datename(day,@d) + ' ' + datename(month, @d) + ', ' + datename(year, @d) as varchar(50)) [PHLetterDate]
from FNOL_Policy p join FNOL_Claims c on p.ID=c.PolicyID
left join syslookup s on c.cause=s.code and s.tablename='fnol - cause'
left join syslookup s1 on p.client=s1.code and s1.tablename='fnol - client'
left join syslookup s2 on c.CoverType=s2.code and s2.tablename='fnol - covertype'
left join syslookup s3 on c.Rank=s3.code and s3.tablename='FNOL - MilitaryRank'
left join syslookup s4 on c.Regiment=s4.code and s4.tablename='FNOL - MilitaryRegiment'
left join syslookup s5 on c.MaritalStatus=s5.code and s5.tablename='FNOL - MaritalStatus'
left join syslookup s6 on c.Cause=s6.code and s6.tablename='FNOL - Cause'
left join ppd3.dbo.OfficeDetails od on od.channel='af' and od.AccountRef=case when p.client not in ('abacus','jbi') then 'af' else p.client end
left join (
	select t.policyid, 
	sum([Contact Lenses]) [Contact Lenses],
	sum([Contents]) [Contents],
	sum([Pedal Cycles]) [Pedal Cycles],
	sum([Laptop]) [Laptop],
	sum([Military Kit]) [Military Kit],
	sum([Desktop PC]) [Desktop PC],
	sum([Personal Possessions]) [Personal Possessions],
	sum([Spectacles]) [Spectacles],
	sum([Tenants Liability]) [Tenants Liability]
	from (
	select pl.policyid,
		case when pl.[type]='CL' then pl.suminsured else 0 end [Contact Lenses],
		case when pl.[type]='CT' then pl.suminsured else 0 end [Contents],
		case when pl.[type]='CY' then pl.suminsured else 0 end [Pedal Cycles],
		case when pl.[type]='LT' then pl.suminsured else 0 end [Laptop],
		case when pl.[type]='MK' then pl.suminsured else 0 end [Military Kit],
		case when pl.[type]='PC' then pl.suminsured else 0 end [Desktop PC],
		case when pl.[type]='PP' then pl.suminsured else 0 end [Personal Possessions],
		case when pl.[type]='SP' then pl.suminsured else 0 end [Spectacles],
		case when pl.[type]='TL' then pl.suminsured else 0 end [Tenants Liability]
		from fnol.dbo.FNOL_PolicyLimits pl
	) t group by t.policyid
)x 	on p.id=x.policyid
where c.clientrefno=@claimref
GO
