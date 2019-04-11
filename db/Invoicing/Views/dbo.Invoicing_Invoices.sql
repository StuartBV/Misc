SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Invoicing_Invoices] as

select 
	IsNull(ic.V2SageAccountRef, o.Channel + case when o.SourceType not in (1, 2, 4, 6) then 'V4' else 'V2' end) AccountRef, 
	o.OrderDate OrderSentDate, 
	o.CreateDate InvoiceCreateDate, 
	IsNull(NullIf(o.Reference, ''), 'Not entered') Reference, 
	o.[Id] InvoiceNo, 
	o.DeliveryId, 
	a.TotalPriceNet PriceNet, a.TotalPriceGross PriceGross, a.TotalPriceGross-a.TotalPriceNet VatAmount, 
	IsNull(cu.Forename, '') Forename, IsNull(cu.Surname, '') Surname, 	IsNull(ad.Postcode, '') Postcode, 
	o.SupplierName, 
	o.Category, 
	o.SupplierId, 
	o.SourceType, o.SourceKey, 
	o.SageSentDate, o.BordereauSentDate, o.BordereauNo, o.Channel, a.Vatrate, 
	'-> Breakdown costs' [ ], 
	a.ProductPriceNet, a.ProductPriceGross, 
	a.OrderChargesNet, a.OrderChargesGross, 
	a.DeliveryCostNet, a.InstallCostNet, a.DisposalCostNet, a.DeliveryCostGross, a.InstallCostGross, a.DisposalCostGross, 
	a.VATDeducted
from Invoicing_Orders o
join Invoicing_Amounts a on a.DeliveryId=o.DeliveryId
left join Invoicing_Customer cu on cu.[Id]=o.CustomerId
left join Invoicing_Address ad on o.DeliveryId=ad.DeliveryId
left join PPD3.dbo.ValidationSuppliers vs on vs.[Type]=o.Channel and vs.SupplierID=o.SupplierId
left join PPD3.dbo.InsuranceCos ic on o.InscoID=ic.ID
where o.Channel is not null
and vs.SupplierID is null

GO
