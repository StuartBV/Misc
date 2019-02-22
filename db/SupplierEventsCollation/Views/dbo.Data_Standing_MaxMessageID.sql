SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Data_Standing_MaxMessageID] as

select max(messageID) messageID,sourcekey,supplierID,messageType
from data_standing
group by sourcekey,supplierID,MessageType

GO
