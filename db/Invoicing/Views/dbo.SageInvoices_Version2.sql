SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SageInvoices_Version2] as
select o.DeliveryId,
	'"SI"' TransType,
	'"' + IsNull(ic.V2SageAccountRef, o.Channel + case when o.SourceType not in (1,2,3,4,6) then 'V4' else 'V2' end) + '"' AccountRef,
	'"' + m.NominalCode + case when i.CategoryId=0 then ' - ' + IsNull(i.Category,'?') else '' end + '"' SalesCode,
	'"1"' Department,
	'"'+Convert(char(10),GetDate(),103)+'"' InvoiceDate,
	'"' + IsNull(NullIf(o.Reference,''),'Not entered') + '"' Reference,
	i.InvoiceId InvoiceNumber,
	i.Amount,
	'"T1"' VatCode,
	i.Vat
from Invoicing_Orders o
cross apply (
	select
		Sum(i.PriceNet + IsNull(c.PriceNet,0)) Amount,
		Sum((i.PriceGross-i.PriceNet) + isnull(c.PriceGross-c.PriceNet,0) ) Vat,
		i.InvoiceId, i.CategoryId, i.Category
	from INVOICING_Items i 
	left join Invoicing_ItemCharges c on c.ItemId=i.ItemId
	where i.DeliveryId=o.DeliveryId --and i.PriceNet>0
	group by i.InvoiceId, i.CategoryId, i.Category
)i
left join PPD3.dbo.ValidationSuppliers vs on vs.[Type]=o.Channel and vs.SupplierID=o.SupplierId
left join PPD3.dbo.InsuranceCos ic on ic.ID=o.InscoID
outer apply (
	select top 1 m.NominalCode
	from InvoiceExport_NominalCodes_Map m
	left join SN_Distributors d on d.ID=o.SupplierId
	where ((m.CategoryId=i.CategoryId and m.SupplierId=0) or (m.CategoryId=0 and m.SupplierId=o.SupplierId and o.SupplierId>0)) and (d.IsJewellery=m.IsJewellery)
	order by m.SupplierId desc
)m
where
	o.Channel is not null
	and o.SourceType not in (2,4,6)
	and vs.SupplierID is null
	and o.SageSentDate is null
	and i.InvoiceId is not null
GO
