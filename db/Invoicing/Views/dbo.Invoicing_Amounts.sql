SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Invoicing_Amounts] as 
select i.DeliveryId,
		i.PriceNet + isnull(oc.PriceNet,0) + isnull(c.PriceNet,0) TotalPriceNet,			-- sum of all products and charges
		i.PriceGross + isnull(oc.PriceGross,0) + isnull(c.PriceGross,0) TotalPriceGross,	-- sum of all products and charges
		i.PriceNet ProductPriceNet,
		i.PriceGross ProductPriceGross,
		isnull(oc.PriceNet,0) OrderChargesNet,
		isnull(oc.PriceGross,0) OrderChargesGross,
		isnull(c.Pricenet,0) ItemChargesNet,-- Sum of del/inst/disp charges
		isnull(c.pricegross,0) ItemChargesGross, -- Sum of del/inst/disp charges
		isnull(c.DeliveryCostNet,0)DeliveryCostNet,		-- Included in c.PriceNet
		isnull(c.DeliveryCostGross,0)DeliveryCostGross,	-- Included in c.PriceGross
		isnull(c.InstallCostNet,0)InstallCostNet,			-- Included in c.PriceNet
		isnull(c.InstallCostGross,0)InstallCostGross,		-- Included in c.PriceGross
		isnull(c.DisposalCostNet,0)DisposalCostNet,		-- Included in c.PriceNet
		isnull(c.DisposalCostGross,0)DisposalCostGross,	-- Included in c.PriceGross
		i.Vatrate,
		i.VATDeducted -- Commercial Claims
	from
	Invoicing_items_totals i
	left join Invoicing_ItemCharges_Totals c on c.DeliveryId=i.DeliveryId
	left join Invoicing_Order_Charges_Totals oc on oc.DeliveryId=i.DeliveryId

GO
