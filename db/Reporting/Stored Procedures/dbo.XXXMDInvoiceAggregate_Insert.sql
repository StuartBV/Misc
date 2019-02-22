SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[XXXMDInvoiceAggregate_Insert]
AS

truncate table dbo.NonDFInvoicingAggregates

return

insert into Reporting.dbo.NonDFInvoicingAggregates (ClaimID, Total, Commodity)
select oi.claimid, isnull(sum(oi.InvoicePrice),0) as total, ''
from SN_PPD3_OrderItems oi
join SN_PPD3_Products p on p.prodid=oi.prodid and p.distributor in (6260)
where oi.[type]='Q' and oi.createdate > '20100315' 
group by oi.claimid 

GO
