SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Invoicing_ItemCharges_Totals] as
select DeliveryId,Vatrate,sum(pricenet) PriceNet,sum(pricegross) PriceGross,

			sum(case when [type]=1 then pricenet else 0 end)  [DeliveryCostNet],
			sum(case when [type]=2 then pricenet else 0 end) [InstallCostNet],
			sum(case when [type]=3 then pricenet else 0 end) [DisposalCostNet],
			sum(case when [type]=1 then pricegross else 0 end) [DeliveryCostGross],
			sum(case when [type]=2 then pricegross else 0 end) [InstallCostGross],
			sum(case when [type]=3 then pricegross else 0 end) [DisposalCostGross]

from Invoicing_ItemCharges
group by DeliveryId,VATRate
GO
