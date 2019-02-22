SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetClaimDetails_InputWizardPage1] 
	
	@ClaimID VARCHAR(50)
	
as

set nocount on 
set transaction isolation level read uncommitted

	select
	
		cl.ClaimID,
		isnull(P.PolicyNo,'') PolicyNo,
		isnull(cl.ClientRefNo,'') ClientRefNo,
		convert(varchar(12),cl.IncidentDate,103) IncidentDate,
		isnull(cl.AccountYear,'') AccountYear,
		isnull(cl.ClaimHandler,'') ClaimHandler,
		isnull(cl.Title,'') title,
		isnull(cl.Fname,'') Fname,
		isnull(cl.Sname,'') Sname,
		isnull(cl.description,'') description,
		isnull(cover.description,'') covertype,
		isnull(countryofLoss.Description,'') countryOfLoss,
		isnull(cause.description,'') Cause,
		isnull([laptopinvolved].Description,'') LaptopInvolved,
		isnull(cl.serviceno,'') ServiceNo,
		isnull(rank.description,'') rank

	from FNOL_Claims cl
	
	JOIN FNOL_Policy P  ON cl.PolicyID=p.ID AND cl.claimid=@ClaimID

	left join syslookup cover  on cl.covertype=cover.code and cover.tablename='fnol - covertype'
	left join syslookup cause  on cl.cause=cause.code and cause.tablename='fnol - cause'
	left join syslookup countryofLoss  on cl.countryofLoss=countryofLoss.[code] and countryofLoss.tablename='fnol - countryofloss'
	left join syslookup [rank]  on cl.[rank]=[rank].code and [rank].tablename='fnol - militaryrank'
	left join syslookup [laptopinvolved]  on cl.[laptopinvolved]=[laptopinvolved].[code] and [laptopinvolved].tablename='FNOL - LaptopInvolved'

GO
