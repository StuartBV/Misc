SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPolicyDetails] 
@policy int
AS
SET NOCOUNT ON
Set transaction isolation level read uncommitted
select
	p.ID ID,
	PolicyNo,
	Client.description Client,
	[Scheme].description [scheme],
	co.company,
	underwriter.description Underwriter,	
	CustomerID,
	convert(varchar(12),DOB,103) DOB,
	covertype.description CoverType,
	convert(varchar(12),inceptiondate,103) InceptionDate,
	convert(varchar(12),ChangeDate,103) ChangeDate,
	convert(varchar(12),cancellationdate,103) CancellationDate,
	Title,
	Fname,
	Lname,
	Address1,
	Address2,
	Address3,
	Town,
	County,
	Postcode,
	Country,
	Hphone,
	Wphone,
	Mphone,
	Fax,
	email,
	ServiceNo,
	maritalstatus.description MaritalStatus,
	rank.description Rank,
	regiment.description Regiment
FROM FNOL_Policy p  JOIN fnol_customers c  ON p.CustomerID=c.ID
left join fnol_companies co  on p.companyid=co.id
left join syslookup client  on p.client=client.code and client.tablename='fnol - client'
left join syslookup [scheme]  on p.scheme=[scheme].code and [scheme].tablename='fnol - scheme'
left join syslookup underwriter  on p.underwriter=underwriter.code and underwriter.tablename='fnol - underwriter'
left join syslookup rank  on p.rank=rank.code and rank.tablename='fnol - militaryrank'
left join syslookup regiment  on p.regiment=regiment.code and regiment.tablename='fnol - militaryregiment'
left join syslookup maritalstatus  on p.maritalstatus=maritalstatus.code and maritalstatus.tablename='fnol - maritalstatus'
left join syslookup covertype  on p.covertype=covertype.code and covertype.tablename='fnol - covertype'
WHERE p.ID=@policy
SELECT
	a.ID LimitID, 
	a.PolicyID,
	a.SumInsured,
	a.Excess,
	limittype.description [Type]	
FROM FNOL_PolicyLimits a JOIN FNOL_Policy b ON b.id=a.PolicyID 
left join syslookup limittype  on a.type=limittype.code and limittype.tablename='fnol - limittype'
WHERE b.ID=@policy

Set transaction isolation level read committed


GO
