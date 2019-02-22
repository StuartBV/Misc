SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[GPReportAggregates_DeleteWhereInOrderItemChanged]
as
delete from r
from GPReportAggregates r where exists (select * from Orderitems_Changed o where o.claimid=r.claimid)

GO
