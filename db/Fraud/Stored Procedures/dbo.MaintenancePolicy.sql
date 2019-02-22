SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy] as

set nocount on
declare @months int=72, @dt date=getdate() 

delete from wip_report where datediff(mm,weekstart,@dt)>=12
delete from Bookings where datediff(mm,CreateDate,@dt)>=@months 
delete from FraudLog where datediff(mm,TransDate,@dt)>=@months 

GO
