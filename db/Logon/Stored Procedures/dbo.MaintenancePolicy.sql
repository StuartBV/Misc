SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[MaintenancePolicy] as
set nocount on
declare @dt date=getdate(), @less90 datetime=getdate()-90, @less30 datetime=getdate()-30

delete from AuthLog where datediff(mm,CreateDate,@dt)>12
update UserData set
	Deleted = 'Y',
	AlteredDate=@dt,
	AlteredBy='sys.Maintenance'
where LastAuth<@less90 and AlteredDate<@less90 and Deleted !='Y'
update UserData set
	[Enabled] = 0,
	AlteredDate=@dt,
	AlteredBy='sys.Maintenance'
where LastAuth<@less30 and AlteredDate<@less30 and [Enabled] = 1 and Deleted != 'Y'

GO
