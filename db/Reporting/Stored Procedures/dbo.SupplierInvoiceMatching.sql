SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupplierInvoiceMatching]
@supplierid int, 
@fd datetime,
@td datetime,
@userID UserID,
@customDiscount decimal(8,3)=1
as
set nocount on
set dateformat dmy

declare @ReportNo int
select @ReportNo=isnull(max(ReportNo),0)+1 from SupplierInvoiceMatch

exec SupplierInvoiceMatching_GetSupplierInvoices @supplierid, @fd, @td, @userID, @ReportNo

-- Build list of matching orders from CMS and ordering
exec SupplierInvoiceMatching_GetCmsOrders_Data @ReportNo, @userID	-- CMS Supplier Delivery
exec SupplierInvoiceMatching_GetOrderingSystem_Data @ReportNo, @userID -- Ordering System

-- Apply match results
exec SupplierInvoiceMatching_MatchTotals @ReportNo,@fd,@customDiscount

-- Results
select [ID], OriginatingSystem,SupplierID, SupplierRef,ClaimID, Channel, InvoiceNumber, OrderNo, convert(char(10),InvoiceDate,103) InvoiceDate, InvoiceTotal, OrderTotal, Variance, MatchCode, Commodity
--, Discount -- removed discount as per requirement specified in Atom 41966, " I do not want the report to tell me waht the % discount is being charged, as it seems to be doing"
from SupplierInvoiceMatch
where ReportNo=@ReportNo

GO
