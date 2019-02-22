SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Comet_CPLEstimateIDs]
@sourcekey int,
@supplierid int
as

set nocount on

select ds.sourcekey,ds.CPLEstimateID,sl.[description] [Type], 
	di.CatNum,di.Description, di.NetPrice, (
			select min(createdate)
			from SupplierEventsCollation.dbo.Data_Standing x
			where x.sourcekey=ds.sourcekey and x.SupplierID=ds.SupplierID and x.Data=ds.data
	) FirstCreated
from SupplierEventsCollation.dbo.Data_Standing_SupplierEvents dsce 
join SupplierEventsCollation.dbo.Data_Standing ds on ds.MessageID=dsce.messageID
join messagequeue.dbo.ClaimEvents ce on ce.EventID=ds.EventID
join ppd3.dbo.syslookup sl on sl.tablename='ClaimEvents' and sl.code=ce.eventtypeID
join SupplierEventsCollation.dbo.Data_Item di on di.MessageID=ds.MessageID
where dsce.sourcekey=@sourcekey
and dsce.supplierid=@supplierid
order by 7
GO
