SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupplierInvoiceMatching_GetSupplierInvoices]
@supplierid int,
@fd datetime,
@td datetime,
@userID UserID,
@ReportNo int
as
set nocount on

insert into SupplierInvoiceMatch (ReportNo,userID,ClaimID, Did,SupplierID,SupplierRef,OrderNo,InvoiceNumber,InvoiceDate,InvoiceTotal, MatchCode, InvoiceType, PreviouslyChecked, PreviouslyCheckedBy, ExportedDate,InvoiceNetTotal,InvoiceVat, CheckId, InvoiceId) 

select @ReportNo,@userID,si.ClaimID,si.Did,@supplierID, si.poref, si.orderref, si.invoiceno, si.InvoiceDate, si.invoicevalue,
	 'Not matched', si.InvoiceType, case when sim.Id is null then 0 else 1 end as PreviouslyChecked, isnull(sim.CheckedBy,''), 
	 sim.Exported, si.NetAmount, si.VatAmount, si.CheckId, si.Id
from SupplierInvoices_ForMatching si
left join SN_PPD3_SupplierInvoices_Matched sim on sim.Id=si.CheckId
where si.SupplierID=@supplierid
and si.InvoiceDate between @fd and @td
and si.poref is not null
GO
