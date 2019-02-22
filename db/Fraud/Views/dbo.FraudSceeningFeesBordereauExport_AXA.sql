SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[FraudSceeningFeesBordereauExport_AXA] as

select top 100 percent InsuranceClaimNo,InsuredSurname,InsuredForename,Postcode,Supplier,InvoiceReference,
	AmountPayable,XSDeducted,ArticleDescription,FinalInvoice,InsuranceCompany,LossAdjuster,LAref, AccountRef
from (
	select 'AXA I Claim Number' as InsuranceClaimNo,
	'Insured''s Surname' as InsuredSurname,
	'Insured''s First Name/ Initials' as InsuredForename,
	'Post Code' as Postcode,
	'Supplier Name' as Supplier,
	'Supplier Invoice Reference Number' as InvoiceReference,
	'Amount Payable (£)' as AmountPayable,
	'Excess Deducted? (Y/N)' as XSDeducted,
	'Article Description' as ArticleDescription,
	'Final Invoice (Y/N)' as FinalInvoice,
	'Insurance Company' as InsuranceCompany,
	'Loss Adjuster' as LossAdjuster,
	'LA Ref' as LAref,
	'Account reference' as AccountRef,
	'Originating Office' as OriginatingOffice,
	0 as seq

	union all

	select c.InsuranceClaimNo,
	cu.LName as InsuredSurname,
	isnull(cu.Title,'') + case when cu.title is not null then '. ' else '' end + isnull(cu.[Fname],'') as InsuredForename,
	isnull(cu.[Postcode],'') as Postcode,
	'Powerplay' as Supplier,
	cast(v.InvoiceID as varchar) as InvoiceReference,
	cast(v.Gross as varchar) AmountPayable,
	case when isnull(c.excess,0)>0 then 'Y' else 'N' end as XSDeducted,
	'Fraud Fee' as ArticleDescription,
	'Y' as FinalInvoice,
	ic.[name] as InsuranceCompany,
	isnull(la.[name],'') as LossAdjuster,
	LossAdjusterRef,
	c.AccountRef,
	c.OriginatingOffice,
	1 as seq
	from fees v join ppd3.dbo.claims c on c.claimid=v.claimid and c.channel=v.channel and c.OfficeGroupID=1
	join ppd3.dbo.customers cu on cu.[id]=c.custID
	join ppd3.dbo.insurancecos ic on ic.id=c.insurancecoid
	left join ppd3.dbo.lossadjusters la on la.ID=c.LossAdjusterID
	where v.channel='AXA' and v.invoicesent is null
	and v.gross>0 and ppd3.dbo.InvoiceSendMethod_For_AXA (c.claimid)=0 -- Send By Bordereau
) x order by seq

GO
