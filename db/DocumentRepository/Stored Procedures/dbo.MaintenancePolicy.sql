SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[MaintenancePolicy] as

set nocount on

declare @months int=72, @dt datetime=getdate() 

delete from Letters where datediff(mm,CreateDate,@dt)>=@months

GO
