SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Email_customerDetails]
@claimid int
as

set nocount on
set transaction isolation level read uncommitted

select c.Title+' '+c.Sname [#customer#],
c.Email [#email#],
convert(varchar(10),getdate(),103) [#date#],
c.ClientRefNo [#claimref#],
p.PolicyNo [#policyno#],
convert(varchar(10),c.IncidentDate,103) [#incidentdate#],
od.PhoneNumber [#telephoneno#],
p.Client+' Claims Unit' [#claimsunit#]
from fnol_claims c
join FNOL_Policy p on p.id=c.PolicyID
left join ppd3.dbo.OfficeDetails od on od.channel='af' and od.AccountRef=case when p.client not in ('abacus','jbi') then 'af' else p.client end
where claimid=@claimid

GO
