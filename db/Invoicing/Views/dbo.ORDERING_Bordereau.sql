SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[ORDERING_Bordereau]
as
select 
	i.InvoiceNo, i.Reference InsCoReference, coalesce(convert(bigint, v.vno), x.ItemReference,'') ValidationNo, i.OrderSentDate OrderDate, i.Forename CustomerForename, i.Surname CustomerSurname, i.Postcode DeliveryPostcode, i.SupplierName,
	i.ProductPriceGross ItemsValue, i.DeliveryCostGross DeliveryCost, i.InstallCostGross InstallationCost, i.DisposalCostGross DisposalCost, i.OrderChargesGross OrderCharges, 
	i.DeliveryCostGross + i.InstallCostGross + i.DisposalCostGross + i.OrderChargesGross AdditionalCost,
	i.PriceGross Total, i.Channel, i.BordereauSentDate, i.SageSentDate, i.AccountRef, i.DeliveryId, i.VATDeducted, x.ExcessDeducted
from Invoicing_Invoices i
left join VALIDATOR2.dbo.Basket_VNO v on v.BasketId=i.SourceKey and i.SourceType=1
outer apply (select top 1 itemreference, odi.ExcessDeducted from ordering.dbo.Ordering_DeliveryItems odi where odi.DeliveryId = i.DeliveryId order by odi.ItemId) x
where i.SourceType not in (2,4,6) and i.BordereauSentDate is null




GO
