SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[INVOICING_Items_PopulateCategoryId] as

update i set i.CategoryId=oi.CategoryId
from INVOICING_Items i
join ordering..Ordering_DeliveryItems oi on i.DeliveryItemId=oi.ItemId
where i.CategoryId=0
GO
