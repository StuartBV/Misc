SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[InvoiceMessageData_Get]
@QueueID int
as

set nocount on

-- Return new invoice
exec InvoiceMessageData_Get_Invoice @QueueID

-- Uncomment below to return data for the previous invoice credit

/*
declare @PrevQueueID int	-- QueueID of last invoice if this is a revised invoice

if exists (select * from SupplierEventsCollation.dbo.CPLInvoiceNumber where Seq>1 and messageid=@QueueID)
begin
	
select @PrevQueueID=i1.messageID
from SupplierEventsCollation.dbo.CPLInvoiceNumber i1
join SupplierEventsCollation.dbo.CPLInvoiceNumber i2 on i2.sourcekey=i1.sourcekey and i2.invoicenumber=i1.invoicenumber and i2.supplierid=i1.supplierid and i1.seq=i2.seq-1
where i2.messageid=@QueueID

exec InvoiceMessageData_Get_Invoice @PrevQueueID, 'C'
end

*/
GO
