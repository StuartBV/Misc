SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Invoicing_Order_Charges_Totals] as
select DeliveryId,InvoiceID,Vatrate,sum(pricenet) PriceNet,sum(pricegross) PriceGross
from Invoicing_Order_Charges
group by DeliveryId,InvoiceId,VATRate
GO
