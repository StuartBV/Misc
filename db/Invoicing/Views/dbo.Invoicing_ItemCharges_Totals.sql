SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Invoicing_ItemCharges_Totals] as
select DeliveryId,VatRate,Sum(PriceNet) PriceNet,Sum(PriceGross) PriceGross,

Sum(case when [Type]=1 then PriceNet else 0 end) DeliveryCostNet,
Sum(case when [Type]=2 then PriceNet else 0 end) InstallCostNet,
Sum(case when [Type]=3 then PriceNet else 0 end) DisposalCostNet,
Sum(case when [Type]=1 then PriceGross else 0 end) DeliveryCostGross,
Sum(case when [Type]=2 then PriceGross else 0 end) InstallCostGross,
Sum(case when [Type]=3 then PriceGross else 0 end) DisposalCostGross

from Invoicing_ItemCharges
group by DeliveryId,VatRate
GO
