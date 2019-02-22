SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[CPLInvoiceNumber]
as
select SourceKey, SupplierID, MessageID, InvoiceNumber, seq, 
	case when InvoiceNumber is null then
		Data + '/' + dbo.Pad(cast(seq as varchar), 2, '0')
	else
		cast(InvoiceNumber as varchar) + '/'+ dbo.Pad(cast(seq as varchar), 2, '0')
	end CPLInvoiceNumber,
	Data
from (
	select  ds1.MessageID, ds1.SourceKey, ds1.SupplierID, ds1.InvoiceNumber,
		(
			select count(*) from Data_Standing ds2
			where ds2.SourceKey=ds1.SourceKey
			and (ds2.InvoiceNumber=ds1.InvoiceNumber or ds2.Data=ds1.Data)
			and ds2.MessageType=ds1.MessageType
			and ds2.MessageID <= ds1.MessageID
			and ds1.EventType=0
		) seq, 
	ds1.Data
	from Data_Standing ds1
	where ds1.MessageType='I'
)x

GO
