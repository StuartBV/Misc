SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[genrep_SupplierInvoiceMatch]
@supplierid int, 
@from varchar(10),
@to varchar(10),
@userid UserID
as

set nocount on
set dateformat dmy

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

exec SN_Reporting_SupplierInvoiceMatching @supplierID, @fd, @td, @userID,1
GO
