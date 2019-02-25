SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[PolicyHeaderDetails] as
select cc.id [companyid],cc.ClaimNoPrefix + cast(p.ICardsID as varchar) as iCardsID, p.[status], cc.Company, p.InsuranceCoID, i.Name as InsCoName, 
p.InsuranceClaimNO, case when p.SePScode='0' then '' else p.SePScode end  as SePScode, 
isnull(s.AccountRef+' - '+s.SchemeName,'') as SePSCodeDesc, p.InsurancePolicyNo, p.OrigOffice, 
p.IValRef, convert(char(10),p.IncidentDate,103) as IncidentDate, p.ContactName, p.ContactPhone, 
convert(char(10),p.CreateDate,103)+' '+convert(char(5),p.CreateDate,14) as CreateDate, p.createdby, cu.ID as customerid, cu.Title, 
cu.FirstName, cu.LastName, cu.Address1, cu.Address2, cu.Town, cu.County, cu.PostCode, cu.Country, cu.Phone,p.wizardstage, 
p.alteredby, sys.[description] as WizardDescription,  p.cancelreason,
convert(char(8),p.alteredDate,8) [time], coalesce (e.FName + ' ' + e.SName, 'Administrator') as empname
from card_companies cc
left join policies p on cc.ID = p.CompanyID
left join customers cu on cu.ICardsID = p.ICardsID
left join syslookup sys on sys.tablename='wizardstage' and p.wizardstage=sys.code
left join ppd3.dbo.insurancecos i on i.ID=p.insurancecoID
left join ppd3.dbo.SePSbranches s on p.SePScode=s.AccountRef
left join ppd3.dbo.logon l on p.alteredby=l.UserID
left join ppd3.dbo.employees e on e.[Id] = l.UserFK

GO
