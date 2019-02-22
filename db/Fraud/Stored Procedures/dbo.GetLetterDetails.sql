SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetLetterDetails]
@claimref int
as
set nocount on
set transaction isolation level read uncommitted

select
case when c.channel in ('ival','nuibrad') then cast(c.OriginClaimID as varchar(50))else cast(c.InsuranceClaimNo as varchar(50)) end [PHrefno], 
c.OriginClaimID [PHourref],
c.InsurancePolicyNo [PHpolicyno],
isnull(convert(varchar(12),c.IncidentDate,113),'') [PHincidentdate],
convert(varchar(12),getdate(),106) [PHcreatedate],
ppd3.dbo.Title(cu.Title)+' ' [PHtitle],
ppd3.dbo.Title(ltrim(isnull(cu.Fname,'')+' '+isnull(cu.Lname,''))) [PHname],
ppd3.dbo.Title(isnull(cu.Lname,'')) [PHsurname],
cu.Address1 [PHaddress1],
cu.Address2 [PHaddress2],
cu.town [PHcity],
cu.County [PHcounty],
cu.Postcode [PHpostcode],
cu.Hphone [PHhomephone],
cu.Wphone [PHworkphone],
cu.Mphone [PHmobile],
cu.Email [PHemail],
c.ClaimReceivedDate [PHdatenotified],
c.CauseofClaimNotes [PHclaimdetails],
c.CauseofClaim [PHcauseofclaim],
c.CrimeRefNumber [PHcrimeref],
od.hubname [PHteamname],
od.officename [PHofficename],
od.Address1 [PHofficeroad],
od.Town [PHofficetown],
od.County [PHofficecounty],
od.Postcode [PHofficepostcode],
od.PhoneNumber [PHofficephoneno],
od.FaxNumber [PHofficefaxno],
od.Email [PHofficeemail],
isnull(upper(sys.[description]),'') [PHrisk],
isnull(e.fname + ' ' + e.SName,'') [PHclaimhandler]
from fraud f join Claims c  on f.ClaimID = c.ClaimID 
join Customers cu on cu.id=c.CustID
join syslookup sys on sys.tablename='Risk' and sys.code=f.Risk
left join ppd3.dbo.logon l on l.userid=f.ClaimHandler
left join ppd3.dbo.employees e on e.id=l.UserFK
left join OfficeDetails od on od.channel=c.channel
where f.claimid=@claimref

GO
