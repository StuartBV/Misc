SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[Invoicing_ItemCharges_PerItem] AS
SELECT DeliveryId,Vatrate,ItemId,sum(pricenet) PriceNet,sum(pricegross) PriceGross,

			sum(CASE WHEN [type]=1 THEN pricenet ELSE 0 END)  [DeliveryCostNet],
			sum(CASE WHEN [type]=2 THEN pricenet ELSE 0 END) [InstallCostNet],
			sum(CASE WHEN [type]=3 THEN pricenet ELSE 0 END) [DisposalCostNet],
			sum(CASE WHEN [type]=1 THEN pricegross ELSE 0 END) [DeliveryCostGross],
			sum(CASE WHEN [type]=2 THEN pricegross ELSE 0 END) [InstallCostGross],
			sum(CASE WHEN [type]=3 THEN pricegross ELSE 0 END) [DisposalCostGross]

FROM Invoicing_ItemCharges
GROUP BY DeliveryId,VATRate,ItemId

GO
