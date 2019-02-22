SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Sage_Invoices] as
select
	'"SI"' TransType,
	i.AccountRef,
	'"4000"' SalesCode,
	'"1"' Department,
	'"'+convert(char(10),getdate(),103)+'"' InvoiceDate,
	i.Reference,
	i.InvoiceNo InvoiceNumber,
	i.PriceNet Amount,
	'"T1"' VatCode,
	i.VatAmount Vat,
	Channel
from 
Invoicing_Invoices i
where i.SageSentDate is null
and SourceType not in (2,4,6) -- Added by SD 20160304 Atom 60132 - 5: DF - Atom 67477 -- JD changed to not in as per Atom 69531 02/01/2017
    -- 1 = V2, 3 = ClaimCompanion



GO
