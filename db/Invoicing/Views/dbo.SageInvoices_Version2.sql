SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SageInvoices_Version2] as

select top 1000
	dbo.Quote(TransType) TransType,
	dbo.Quote(IsNull(ic.V2SageAccountRef, i.Channel + i.SourceType)) AccountRef,
	dbo.Quote(NominalCode) NominalCode,
	'"1"' Department,
	dbo.Quote(Convert(char(10),i.CreateDate,103)) InvoiceDate,
	dbo.Quote(Reference) Reference,
	InvoiceNumber, Amount,
	dbo.Quote(VatCode) Vatcode,
	Vat, Channel, Credit, ExportId
from (
	select o.Id InvoiceNumber, o.DeliveryId, o.InscoID, o.Channel, o.SupplierId, o.CreateDate,
		case when o.SourceType not in (1,3) then 'V4' else 'V2' end SourceType,
		'SI' TransType,
		m.NominalCode + case when m.NominalCode='9999' then ' - ' + Coalesce(i.Category, o.Category, '?') else '' end NominalCode,
		IsNull(NullIf(o.Reference,''),'Not entered') Reference,
		i.Amount,
		'T1' VatCode,
		i.Vat, 0 Credit, e.Id ExportId
	from 
	InvoicesToExport e
	join Invoicing_Orders o on o.Id=e.OrderId
	cross apply (
		select
			Round(Sum(i.PriceNet + IsNull(c.PriceNet,0)),2) Amount,
			Round(Sum((i.PriceGross-i.PriceNet) + IsNull(c.PriceGross-c.PriceNet,0) ),2) Vat,
			i.InvoiceId, i.CategoryId, i.Category
		from INVOICING_Items i 
		left join Invoicing_ItemCharges c on c.ItemId=i.ItemId
		where i.DeliveryId=o.DeliveryId 
		group by i.InvoiceId, i.CategoryId, i.Category
	)i
	outer apply dbo.Get_NominalCodeForInvoice(i.CategoryId, o.SupplierId) m
	--where
	--	o.Channel is not null
	--	and o.SourceType not in (2,4,6)
	--	and o.SageSentDate is null

	union all -- Excess

	select 
	o.Id InvoiceNumber, o.DeliveryId,	o.InscoID, o.Channel, o.SupplierId, o.CreateDate,
	case when o.SourceType not in (1,3) then 'V4' else 'V2' end SourceType,
	'SC' TransType,
	'1500' NominalCode,
	IsNull(NullIf(o.Reference,''),'Not entered') Reference,
	o.ExcessCollected Amount,
	'T9' TaxCode,
	0 VatAmount, 1 Credit, e.Id ExportId
	from InvoicesToExport e
	join Invoicing_Orders o on o.Id=e.OrderId
	where o.ExcessCollected>0

	--o.Channel is not null
	--and o.SourceType not in (2,4,6)
	--and o.SageSentDate is null
	--and o.ExcessCollected>0

)i
left join PPD3.dbo.InsuranceCos ic on ic.ID=i.InscoID
where not exists (
	select * from PPD3.dbo.ValidationSuppliers vs
	where vs.[Type]=i.Channel and vs.SupplierID=i.SupplierId
)
order by i.InvoiceNumber
GO
