SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rep_InvoicedCards] 
@headers tinyint=0
--UTC--
as
set nocount on
set transaction isolation level read uncommitted

declare @start datetime=getdate()-7, @end datetime=getdate()

select [ClaimCentre], [InstructorType], [LossAdjusterCode], [LossAdjusterRef], [GrossAmount], [Unitcost], [NetAmount], [VATAmount], [InsurerItemCost],
	[InvoiceNumber], [InvoiceDate], [Agreementdate], [FirstActionDate], [InvoiceGross], [excess], [InvoiceNet], [InvoiceVAT], [InvoiceTotal], [PolicyholderTitle], 
	[PolicyHolderFirstname], [PolicyHolderLastname], [Address1], [Address2], [Town], [County], [Postcode], [PolicyNumber], [ClaimNumber], [InstructionDate],
	[IncidentDate], [InvoicedDate]
from (
	select 'A' seq, 'iVal Options Weekly Invoiced Cards' [ClaimCentre], '' [InstructorType], '' [LossAdjusterCode], '' [LossAdjusterRef],
	'' [GrossAmount], '' [Unitcost], '' [NetAmount], '' [VATAmount], '' [InsurerItemCost],
	'' [InvoiceNumber], '' [InvoiceDate], '' [Agreementdate], '' [FirstActionDate], '' [InvoiceGross],
	'' [excess], '' [InvoiceNet], '' [InvoiceVAT], '' [InvoiceTotal], '' [PolicyholderTitle], 
	'' [PolicyHolderFirstname], '' [PolicyHolderLastname], '' [Address1], '' [Address2],
	'' [Town], '' [County], '' [Postcode], '' [PolicyNumber], '' [ClaimNumber], '' [InstructionDate],
	'' [IncidentDate], ''[InvoicedDate]
	union all
	select 'B' seq, '' [ClaimCentre], '' [InstructorType], '' [LossAdjusterCode], '' [LossAdjusterRef],
	'' [GrossAmount], '' [Unitcost], '' [NetAmount], '' [VATAmount], '' [InsurerItemCost],
	'' [InvoiceNumber], '' [InvoiceDate], '' [Agreementdate], '' [FirstActionDate], '' [InvoiceGross],
	'' [excess], '' [InvoiceNet], '' [InvoiceVAT], '' [InvoiceTotal], '' [PolicyholderTitle], 
	'' [PolicyHolderFirstname], '' [PolicyHolderLastname], '' [Address1], '' [Address2],
	'' [Town], '' [County], '' [Postcode], '' [PolicyNumber], '' [ClaimNumber], '' [InstructionDate],
	'' [IncidentDate], ''[InvoicedDate]
	union all
	select 'C' seq, 'Claim Centre' [ClaimCentre], 'Instructor Type' [InstructorType], 'Loss Adjuster Code' [LossAdjusterCode], 'Loss Adjuster Ref' [LossAdjusterRef],
	'Gross Amount' [GrossAmount], 'Unit Cost' [Unitcost], 'Net Amount' [NetAmount], 'VAT Amount' [VATAmount], 'Insurer Item Cost' [InsurerItemCost],
	'Invoice Number' [InvoiceNumber], 'Invoice Date' [InvoiceDate], 'Agreement Date' [Agreementdate], 'First Action Date' [FirstActionDate], 'Invoice Gross' [InvoiceGross],
	'Excess' [excess], 'Invoice Net' [InvoiceNet], 'Invoice VAT' [InvoiceVAT], 'Invoice Total' [InvoiceTotal], 'Policyholder Title' [PolicyholderTitle], 
	'Policyholder Firstname' [PolicyHolderFirstname], 'Policy Holder Lastname' [PolicyHolderLastname], 'Address1' [Address1], 'Address2' [Address2],
	'Town' [Town], 'County' [County], 'Postcode' [Postcode], 'Policy Number' [PolicyNumber], 'Claim Number' [ClaimNumber], 'Instruction Date' [InstructionDate],
	'Incident Date' [IncidentDate], 'Invoiced Date' [InvoicedDate]
	union all 
	select 'D' as seq,
		s.SePSShortCode as [ClaimCentre],
		'001' as [InstructorType],
		'' as [LossAdjusterCode],
		isnull(c.lossadjusterref,'') as [LossAdjusterRef],
		cast(p.cardvalue as varchar) as [GrossAmount],
		cast(p.cardvalue as varchar) as [Unitcost],
		cast(p.cardvalue as varchar) as [NetAmount],
		'0' as [VATAmount],
		cast(p.cardvalue as varchar) as [InsurerItemCost],
		cast(p.cardvalueid as varchar) as [InvoiceNumber],
		convert(varchar(10),p.transdate,103) as [InvoiceDate],
		convert(varchar(10),p.transdate,103) as [Agreementdate],
		convert(varchar(10),p.transdate,103) as [FirstActionDate],
		cast(p.cardvalue+isnull(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null then c.excess else null end,0) as varchar) as [InvoiceGross],
		cast(isnull(c.excess,0) as varchar) as [excess],
		cast(p.cardvalue as varchar) as [InvoiceNet],
		'0' as [InvoiceVAT],
		cast(p.cardvalue as varchar) as [InvoiceTotal],
		p.title as [PolicyholderTitle],
		p.firstname as [PolicyHolderFirstname],
		p.lastname as [PolicyHolderLastname],
		p.address1 as [Address1],
		isnull(p.address2,'') as [Address2],
		isnull(p.town,'') as [Town],
		isnull(p.county,'') as [County],
		p.postcode as [Postcode],
		p.insurancepolicyno as [PolicyNumber],
		p.insuranceclaimno as [ClaimNumber],
		coalesce(convert(varchar(10),c.createdate,103)  , convert(varchar(10),p.createdate,113) ) as [InstructionDate],
		coalesce(convert(varchar(10),c.incidentdateUTC,103) , convert(varchar(10),p.incidentdate,113) ) as [IncidentDate],
		convert(varchar(10),p.invoiceddate,103) + ' ' + convert(varchar(5),p.invoiceddate,14)  as [InvoicedDate]
	from policydetails p 
	left join ppd3.dbo.claims c  on p.ivalref = c.claimid
	left join ppd3.dbo.sepsbranches s  on s.accountref=p.SepSCode
	where p.invoiceddate between @start and @end and p.[type] in ('B','M') and p.cardvalue > 0 and p.[status] = 2
)x
order by seq
GO
