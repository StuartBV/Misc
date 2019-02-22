SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Shaun Bradley
-- Create date:	04/11/2009
-- Description:	Provides data for new-claim-from-policy page input wizard (page 2 Address, Service)
-- =============================================
CREATE PROCEDURE [dbo].[GetClaimDetails_InputWizardPage2] 
	
	@ClaimID VARCHAR(50)
	
as

set nocount on 
set transaction isolation level read uncommitted

select cl.ClaimID,
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
convert(varchar(12),cl.DOB,103) DOB,

isnull(cl.serviceno,'') ServiceNo,
isnull(cause.description,'') Cause,
isnull(maritalstatus.description,'') maritalstatus,
isnull(rank.description,'') rank,
isnull(left(regiment.description,36),'') regiment,

isnull(cl.c_Address1,'') c_Address1,
isnull(cl.c_Address2,'') c_Address2,
isnull(cl.c_City,'') c_City,
isnull(cl.c_County,'') c_County,
isnull(cl.c_Postcode,'') c_Postcode,
isnull(cl.c_Country,'') c_Country,
isnull(cl.contactname2,'') contactname2,
isnull(cl.contactphone2,'') contactphone2


FROM FNOL_Claims cl  JOIN FNOL_Policy P  ON cl.PolicyID=p.ID AND cl.claimid=@ClaimID
join fnol_companies co  on p.companyid=co.id 
left join syslookup cause  on cl.cause=cause.code and cause.tablename='fnol - cause' 
left join syslookup maritalstatus  on cl.maritalstatus=maritalstatus.code and maritalstatus.tablename='fnol - maritalstatus' 
left join syslookup [rank]  on cl.[rank]=[rank].code and [rank].tablename='fnol - militaryrank' 
left join syslookup regiment  on cl.regiment=regiment.code and regiment.tablename='fnol - militaryregiment'
GO
