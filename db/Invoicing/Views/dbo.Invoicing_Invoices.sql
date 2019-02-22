SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Invoicing_Invoices] as

select 
	isnull(ic.V2SageAccountRef, o.channel + case when o.SourceType not in (1,2,3,4,6) then 'V4' else 'V2' end) [AccountRef], 
	o.OrderDate [OrderSentDate],
	o.createdate [InvoiceCreateDate],
	isnull(nullif(o.Reference,''),'Not entered') [Reference],
	o.[Id] [InvoiceNo],
	o.DeliveryId,
	a.TotalPriceNet PriceNet, a.TotalPriceGross PriceGross, a.TotalPriceGross-a.TotalPriceNet [VatAmount],
	isnull(cu.Forename,'') Forename, isnull(cu.Surname,'') Surname,	isnull(ad.Postcode,'') Postcode,
	o.SupplierName,
	o.Category,
	o.SupplierId,
	o.SourceType, o.SourceKey,
	o.SageSentDate, o.BordereauSentDate, o.BordereauNo, o.Channel,	a.vatrate,
	'-> Breakdown costs' [ ],
	a.ProductPriceNet,a.ProductPriceGross,
	a.OrderChargesNet, a.OrderChargesGross,
	a.DeliveryCostNet, a.InstallCostNet, a.DisposalCostNet,a.DeliveryCostGross, a.InstallCostGross, a.DisposalCostGross,
	a.VATDeducted
from Invoicing_Orders o
join Invoicing_Amounts a on a.DeliveryId=o.DeliveryId
left join dbo.Invoicing_Customer cu on cu.[id]=o.CustomerId
left join dbo.Invoicing_Address ad on o.DeliveryId=ad.DeliveryId
left join ppd3.dbo.ValidationSuppliers vs on vs.type=o.Channel and vs.SupplierID=o.SupplierId
left join PPD3.dbo.InsuranceCos ic on o.InscoID = ic.ID
where o.Channel is not null and vs.SupplierID is null

GO
