SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_GenerateSageCSV_LogConfirmed] as

insert into logging.dbo.Invoicing_InvoiceExport_Sage_Log (TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat)
select
	Replace(TransType,'"',''),
	Replace(AccountRef,'"',''),
	Replace(NominalCode,'"',''),
	Replace(Department,'"',''),
	Replace(InvoiceDate,'"',''),
	InvoiceNumber,
	Replace(Reference,'"',''),
	Amount,
	Replace(VatCode,'"',''),
	Vat
from Worktable_InvoiceExport_Sage

insert into logging.dbo.Invoicing_InvoiceExport_Sage_Log (TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat, [Type])
select
	Replace(TransType,'"',''),
	Replace(AccountRef,'"',''),
	Replace(NominalCode,'"',''),
	Replace(Department,'"',''),
	Replace(InvoiceDate,'"',''),
	InvoiceNumber,
	Replace(Reference,'"',''),
	Amount,
	Replace(VatCode,'"',''),
	Vat, 1
from Worktable_InvoiceExport_SageAggregated

truncate table Worktable_InvoiceExport_Sage
truncate table Worktable_InvoiceExport_SageAggregated

GO
