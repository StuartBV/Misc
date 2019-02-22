SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[StackAggregatesOvernightMaintenance] AS

set nocount on

begin tran
insert into stackAggregatesArchive
	 (claimid,superfmt,channel,qty,invoicepricenet_gbp,invoicepricenet,invoicepricegross_gbp,invoicepricegross,countryid,ppid,ordertype,createdate)
select claimid,superfmt,channel,qty,invoicepricenet_gbp,invoicepricenet,invoicepricegross_gbp,invoicepricegross,countryid,ppid,ordertype,convert(char(8),getdate(),112)
from stackaggregates s
where not exists (select * from StackAggregatesArchive x where x.claimid=s.claimid and s.superfmt=x.superfmt and s.channel=x.channel )
if @@error<>0
begin
	raiserror('SP_StackAggregatesOvernightMaintenance Failure',18,1)
	rollback tran
end
else
begin
	truncate table stackaggregates
	commit tran
end
GO
