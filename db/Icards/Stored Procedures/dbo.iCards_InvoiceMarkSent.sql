SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[iCards_InvoiceMarkSent]
@invoiceno int,
@batchno varchar(20)
AS
return
update transactions set InvoicedDate=getdate(), InvoiceBatchNo=@batchno, AlteredDate=getdate(), Alteredby='invoice'
where ID=@invoiceno
GO
