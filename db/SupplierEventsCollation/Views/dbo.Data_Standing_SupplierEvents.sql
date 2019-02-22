SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE View [dbo].[Data_Standing_SupplierEvents] 

as

select SupplierID,sourcekey,max(messageID) messageID
from Data_Standing
group by sourcekey,SupplierId,data


GO
