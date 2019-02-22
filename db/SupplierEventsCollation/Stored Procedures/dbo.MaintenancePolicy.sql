SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy] as
delete from x from Data_Standing x where not exists (select * from MessageQueue.dbo.[Queue] q where x.MessageID=q.ID)
delete from x from Data_Item x where not exists (select * from MessageQueue.dbo.[Queue] q where x.MessageID=q.ID)
delete from x from MessageLog x where not exists (select * from MessageQueue.dbo.[Queue] q where x.MessageID=q.ID)
GO
