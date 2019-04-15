SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SageInvoices_Version2_Aggregated] as

select top 1000
'"SI"' TransType, AccountRef, '"4999"' NominalCode, Department, InvoiceDate, Reference, InvoiceNumber,
 Sum(Amount  * case when Credit=1 then -1 else 1 end) Amount, '"T1"' VatCode, Sum(Vat) Vat, Channel, ExportId
from SageInvoices_Version2
group by 
 AccountRef, Department, Reference, InvoiceNumber, InvoiceDate, Channel, ExportId
order by InvoiceNumber

GO
