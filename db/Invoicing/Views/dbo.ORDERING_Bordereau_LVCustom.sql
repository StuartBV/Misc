SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[ORDERING_Bordereau_LVCustom]
as
select 
	i.InvoiceNo, i.Reference InsCoReference, v.vno ValidationNo, i.OrderSentDate OrderDate, i.Forename CustomerForename, i.Surname CustomerSurname, i.Postcode DeliveryPostcode, i.SupplierName,
	i.ProductPriceNet ItemCostNet, i.DeliveryCostNet + i.InstallCostNet + i.DisposalCostNet + i.OrderChargesNet NetCosts,
	i.PriceNet TotalPriceNet, i.VatAmount, i.PriceGross TotalPriceGross, i.AccountRef, i.Category, b.Excess, SageSentDate
from Validator2.dbo.Basket_VNO v
join Invoicing_Invoices i on v.BasketId=i.SourceKey
left join validator2..Checkout_Baskets b on b.Id=v.BasketId
where i.SourceType=1 and i.Channel='LV'
GO
