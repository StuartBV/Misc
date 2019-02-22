SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Invoicing_items_totals] as
select DeliveryId, InvoiceId, Vatrate, sum(pricenet) PriceNet, sum(pricegross) PriceGross, sum(VatDeducted) VATDeducted
from Invoicing_Items
group by DeliveryId,InvoiceId,VATRate

GO
