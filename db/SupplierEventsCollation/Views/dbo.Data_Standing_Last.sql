SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Data_Standing_Last] as
select ds.*,x.revision
from (
	select max(messageID) MEssageID,count(*) revision
	from Data_Standing
	group by SourceKey
) x join Data_Standing ds on ds.MessageID=x.MessageID
GO
