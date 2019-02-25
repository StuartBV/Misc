SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy] as

set nocount on
declare @months int=48, @dt date=getdate() 

delete from transactions where datediff(mm,createdate,@dt)>=@months
delete from History_Settlements where datediff(mm,cast(left(replace(ProcessedDate,'-',''),8) as datetime),@dt)>=@months
delete from [Log] where datediff(mm,createdate,@dt)>=@months
delete from Histoy_Authorisations where datediff(mm,Localdate,@dt)>=@months
delete from FIS_Reporting_TransactionExport where datediff(mm,Localdate,@dt)>=@months
delete from SupplierCardLog where datediff(mm,CreatedDate,@dt)>=@months
delete from FISCardResponseLoad where datediff(mm,CreateDate,@dt)>=3
delete from subscription where datediff(mm,CreateDate,@dt)>=@months



-- As of now unable to implement a full policy as high-insert tables are fucking shit. No PKs, no autiting with createdate.
-- Have removed millions of probably legacy data however the author of this database made the accuracy of this task impossible.
-- Have added from 20171106 onward and will have to revisit
--		delete from FIS_Reporting_AccountException where id <4300000
--		delete from FIS_Reporting_ProgramBalance where id <3000000

GO
