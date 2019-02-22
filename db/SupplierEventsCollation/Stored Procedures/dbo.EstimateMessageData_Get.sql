SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EstimateMessageData_Get]
@queueID int
as

set nocount on

-- Get the MessageID of the invoice for this estimate, if the estimate is a Powerplay estimate. Remove "Delta" to revert to snapshot only mode
if exists (select * from SupplierEventsCollation.dbo.Data_Standing where MessageID=@queueID and supplierID=10000100)
	exec EstimateMessageData_Get_Estimate @QueueID
else	
	exec EstimateMessageData_Get_EstimateDelta @QueueID

declare @invoiceMessageID int, @PrevQueueID int
select @InvoiceMessageID=l2.MessageID
from SupplierEventsCollation.dbo.MessageLog l
join SupplierEventsCollation.dbo.MessageLog l2 on l2.sourcekey=l.sourcekey and l2.MessageType='I' and l2.MessageID>l.MessageID
where l.MessageID=@QueueID and l.SupplierID=10000100

if @invoiceMessageID is not null
begin
	-- If there is an invoice, check to see if there is a previous invoice than needs crediting
	if exists (select * from SupplierEventsCollation.dbo.CPLInvoiceNumber where Seq>1 and messageid=@invoiceMessageID)
	begin
		select @PrevQueueID=i1.messageID
		from SupplierEventsCollation.dbo.CPLInvoiceNumber i1
		join SupplierEventsCollation.dbo.CPLInvoiceNumber i2 on i2.sourcekey=i1.sourcekey and i2.invoicenumber=i1.invoicenumber and i2.supplierid=i1.supplierid and i1.seq=i2.seq-1
		where i2.messageid=@invoiceMessageID
		-- Return data for invoice to be credited
		if @PrevQueueId is not null	-- @PrevQueueID could be NULL if the last invoice sent was a credit only
			exec InvoiceMessageData_Get_Invoice @PrevQueueID, 'C'
	end



end

GO
