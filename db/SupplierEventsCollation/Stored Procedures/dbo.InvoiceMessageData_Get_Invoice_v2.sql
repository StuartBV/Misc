SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[InvoiceMessageData_Get_Invoice_v2]
@QueueID int, 
@Type char(1)='I' -- Type, I or C for Invoice or CreditNote
as 
set nocount on

declare @neg int, @dt datetime= getdate()
select @neg=case when @type='C' then -1
 else 1
 end	-- Required as CPL requires values to be negative for credits

if @QueueID is not null 
begin
	select case ds.eventType when 0 then 'Y' else 'N' end DataToSend, 
		ds.messageType, ds.MessageID TransactionID, 
		case ds.InsurancePolicyNo when '' then 'Unknown' else InsurancePolicyNo end PolicyNumber, 
		convert(varchar(10), coalesce(ds.IncidentDate,
		ds.ClaimReceivedDate, @dt), 103) IncidentDate, 
		'NU13 035' RoleTypeCode, 
		isnull(tc.CPLTitleCode, 'B53 003') TitleCode, 
		isnull(tc.CPLTitleDescription, 'Mr') TitleCodeDescription, 
		case when isnull(ds.fname, '')='' then 'Unknown' else left(ds.Fname, 15) end FirstForename, 
		case when isnull(ds.Lname, '')='' then 'Unknown' else left(ds.Lname, 30) end Surname, 
		case when isnull(ds.Address1, '')='' then 'Unknown' else left(ds.Address1, 45) end AddressLine1, 
		isnull(nullif(ds.Postcode, ''), 'Unknown') Postcode, 
		isnull(m.eCode, 'unknown') eSupplierCode, 
		dbo.FormatReference(ds.CPLEstimateID) as SupplierReference, 
		isnull(convert(varchar(10), isnull(ds.ClaimReceivedDate,ds.IncidentDate), 103),'') InstructionDate, 
		case @type when 'I' then 'NU29 001' else 'NU29 002' end InvoiceTypeCode, 
		case when n.CPLInvoiceNumber is null then n1.CPLInvoiceNumber else n.CPLInvoiceNumber end as InvoiceNumber, 
		case when @type='C' then n.CPLInvoiceNumber + 'C' else '' end CreditnoteNumber, 
		ds.invoiceTotal * @neg InvoiceTotal, 
		case when ml.DateSent is null then 'Y' end as SendCancellation, 
		ival.eCode as SupplierCompanyID, ival.SupplierNameForXml as SupplierCompanyName, 
		left(ds.InsuranceClaimNo, 20) as ClaimNumber, 
		convert(varchar(10), isnull(ds.InvoiceSent, @dt), 103) InvoiceDate
		from MessageQueue.dbo.[Queue] q join Data_Standing ds on ds.messageid=q.[id] and ds.MessageType='I'
		join MessageLog ml on ml.sourcekey=ds.sourcekey and ml.supplierID=ds.supplierID and ml.MessageType='I'
		join eCodeMappings_Ranked(@QueueID, null) m on m.messageid=ds.messageid
		join eCodeMappings_Ranked(@queueID, null) ival on ival.messageid=ds.messageid
		left join TitleCodeMappings tc on tc.CMSTitle=ds.Title
		left join CPLInvoiceNumber n on n.sourcekey=ds.sourcekey and n.InvoiceNumber=ds.InvoiceNumber and n.SupplierID=ds.SupplierID and q.[id]=n.messageID
		left join CPLInvoiceNumber n1 on n1.sourcekey=ds.sourcekey and n1.data=ds.Data and n1.SupplierID=6650 and q.[id]=n1.messageID
	where q.[id]=@QueueID

	select 'OR' ListOwner, '1' ListNo, isnull(di.ItemTypeCode, '1050213C') ItemTypeCode, 
		cast(row_number() over ( order by di.sourcekey ) as varchar(20)) SupplierItemReference, 	-- Take your duplicate item reference malarky and shove it
		isnull(nullif(left(di.[description], 50), ''), 'Uknown') ItemDetailDescription, 
		di.sourcekey, sum(di.netprice) * @neg NetPrice, di.vatrate, di.catnum, 'NU10 001' OperationCode, count(*) NoOf, avg(di.NetPrice * @neg) UnitPrice, 
		case when di.VatRate=1 then 'False' else 'True' end VatApplicableInd, 
		avg(di.VatAmount) * @neg VatAmount, 
		cast(( di.vatrate - 1 ) * 100 as decimal(8, 2)) as VatPercent, 
		convert(char(10), cast(avg(cast(cast(convert(char(8), di.ItemCreateDate, 112) as datetime) as int)) as datetime), 120) as RateEffectiveDate, 
		isnull(m.eCode, 'unknown') eSupplierCode
		from MessageQueue.dbo.[Queue] q join Data_Standing ds on ds.messageid=q.[id] and ds.MessageType='I'
		join Data_Item di on di.MessageID=ds.MessageID and di.NetPrice > 0
		join eCodeMappings_Ranked(@QueueID, null) m on m.messageid=ds.messageid
	where q.[id]=@QueueID
	group by di.ItemTypeCode, di.sourcekey, di.VatRate, di.catnum, di.[Description], m.eCode
	
	-- ADD in an excess to deduct off the invoice as a negative line item
	union all
	
	select 'OR' ListOwner, '1' ListNo, '1050030C' ItemTypeCode, 'XS' SupplierItemReference, 'Excess' ItemDetailDescription, 
		ds.sourcekey, 0 - ds.excess * @neg NetPrice, 1 VatRate, 'XS', 'NU10 001' OperationCode, 1 NoOf, 0 - ds.excess * @neg UnitPrice, 
		'False' VatApplicableInd, 0 VatAmount, 0 VatPercent, 
		convert(char(10), isnull(ds.InvoiceSent, @dt), 120) RateEffectiveDate, 
		isnull(m.eCode, 'unknown') eSupplierCode
	from MessageQueue.dbo.[Queue] q join Data_Standing ds on ds.messageid=q.[id] and ds.MessageType='I' and isnull(ds.Excess, 0) > 0
	join eCodeMappings_Ranked(@QueueID, null) m on m.messageid=ds.messageid
	where q.[id]=@QueueID and q.SourceSystem='cms'
	
	order by 7
end



GO
