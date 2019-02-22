SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[SupplierInvoiceCleanData] (@PORef varchar(100), @OrderRef varchar(100), @InvoiceNo varchar(100)	)
returns table
as

	return (
		select * from ppd3.dbo.SupplierInvoiceCleanData (@PORef, @OrderRef, @InvoiceNo)
	)

GO
