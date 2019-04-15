SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Invoice_GenerateSageCSV_Confirm2]
@ExportId bigint
as

set nocount on
update o set o.SageSentDate=GetDate()
from InvoicesToExport i join Invoicing_Orders o on o.Id=i.OrderId
where i.Id=@ExportId
GO
