SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Invoicing_ItemLineCharges] as
select ItemId, VatRate, Sum(PriceNet) PriceNet
from Invoicing_ItemCharges
group by ItemId, VatRate

GO
