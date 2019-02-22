SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ItemPriceNet_Update]
@invoiceitemid int,
@newcostpricenet smallmoney
as
set nocount on

--Update the item cost in the invoice table
update Invoicing_Items set
	PriceNet=@newcostpricenet,
	AlteredDate=getdate(),
	AlteredBy='sys'
where ItemId=@Invoiceitemid

--Update the item cost in the Ordering_Items
update di set
	di.PriceNet=@newcostpricenet,
	altereddate=getdate(),
	alteredby='sys'
from Invoicing_Items i join Ordering.dbo.Ordering_DeliveryItems di on i.DeliveryItemId=di.ItemId
where i.ItemId=@Invoiceitemid

--Update the item cost in V2 Checkout
update v2i set
	v2i.PriceNet=@newCostPriceNet,
	AlteredDate=getdate(),
	AlteredBy='sys'
from Invoicing_Items i join Ordering.dbo.Ordering_DeliveryItems di on di.ItemId=i.DeliveryItemId
join validator2.dbo.CHECKOUT_BasketItems v2i on v2i.BasketItemId=di.SourceKey
where i.ItemId=@Invoiceitemid
GO
