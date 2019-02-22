SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[LastCplInvoiceNumber] as
select invoicenumber,  max(seq) seq from CPLInvoiceNumber group by InvoiceNumber
GO
