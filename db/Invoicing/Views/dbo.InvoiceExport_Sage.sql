SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[InvoiceExport_Sage] as

select top 100 percent
*
--transtype,AccountRef,SalesCode,Department,InvoiceDate,Reference,InvoiceNumber,amount,vatcode,vat
from Worktable_InvoiceExport_Sage
order by invoicenumber


GO
