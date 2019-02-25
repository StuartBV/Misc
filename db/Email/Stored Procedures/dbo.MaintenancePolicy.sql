SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy] as

set nocount on

declare @months int=36, @dt datetime=getdate() 

delete from EmailDboes where datediff(mm,CreateDate,@dt)>=@months
GO
