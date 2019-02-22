SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[LetterDetails] as

select c.clientrefno, p.PolicyNo, convert(varchar(12),c.IncidentDate,113) IncidentDate, c.Title ContactTitle, ltrim(isnull(c.Fname,'')+' '+isnull(c.Sname,'')) ContactName,
c.Address1, c.Address2, c.City, c.County, c.Postcode, c.Hphone, c.Wphone, c.Mphone, c.Email, p.InceptionDate, c.DateNotified, c.[Description], s.[Description] cause,
s2.[Description] covertype, s1.[description] client, c.ClaimHandler, c.Contactname2 secondcontact, c.ContactPhone2 secondcontactno, x.[Contact Lenses], x.Contents,
x.[Desktop PC], x.Laptop, x.[Military Kit], x.[Pedal Cycles], x.[Personal Possessions], x.Spectacles, x.[Tenants Liability]
from FNOL_Policy p join FNOL_Claims c on p.ID=c.PolicyID
left join syslookup s on c.cause=s.code and s.tablename='fnol - cause'
left join syslookup s1 on p.client=s1.code and s1.tablename='fnol - client'
left join syslookup s2 on c.CoverType=s2.code and s2.tablename='fnol - covertype'
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
		from FNOL_PolicyLimits pl
	) t group by t.policyid
)x 	on p.id=x.policyid

GO
