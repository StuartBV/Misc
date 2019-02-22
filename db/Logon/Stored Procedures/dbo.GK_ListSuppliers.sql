SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_ListSuppliers] as
set nocount on

declare @dt datetime=dateadd(yy,-4,getdate())

select d.id,d.[Name]
from ppd3.dbo.Distributor d
where createdate > @dt-- bring back last 4 years distributors
and id !='10000100' and name !=''
order by name

GO
