SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Data_Standing_MessageIDs] as
select 
	MessageID, case when q.[id] is null then LastMessageID else 0 end LastMessageID
	from (
	select max(ds2.MessageID) LastMessageID,max(ds.MessageID) MessageID
	from Data_Standing ds
	join Data_Standing ds2 on ds2.sourcekey=ds.sourcekey and ds2.MessageType=ds.MessageType and ds2.SupplierID=ds.SupplierID and ds2.MessageID<ds.MessageID
)m
left join MessageQueue.dbo.Queue q on q.[id]=LastMessageID and q.DataRetrieved=1 and q.DateSent is not null


GO
