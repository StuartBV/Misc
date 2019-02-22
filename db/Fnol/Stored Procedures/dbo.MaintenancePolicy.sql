SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy] as

set nocount on
declare @months int=72, @dt date=getdate() 

delete from FNOL_Policy where datediff(mm,CreatedDate,@dt)>=@months 
delete from l from FNOL_PolicyLimits l where not exists (select * from FNOL_Policy p where p.ID=l.PolicyID)
delete from DocumentScanHeaders where datediff(mm,CreateDate,@dt)>=@months 
delete from t from DocumentScanHeadersType t where not exists (select * from DocumentScanHeaders s where s.ScanID=t.ScanID )
delete from UserTracking where datediff(mm,[Date],@dt)>12

GO
