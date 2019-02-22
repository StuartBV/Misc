SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Data_Standing_CometEvents] as
select max(messageID) messageID,sourcekey
from Data_Standing
where SupplierID=6085
group by data,sourcekey

GO
