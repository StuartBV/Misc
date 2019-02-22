SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[XXXIR_WIP_PopulateReportingTable]
AS
SET NOCOUNT ON

-- Remove all claims which have changed
delete from rep
from Reporting.dbo.IR_WIP_Claims rep
join ppd3.dbo.Claims c on c.claimid=rep.claimid
join reporting.dbo.IP_WIP_ClaimCategory as ccsv on ccsv.claimid=c.claimid
where (rep.ClaimStatus<>c.[status]
or rep.DateOfCompletion<>case when c.[status]=20 then c.CompletedDate else c.CancelDate end
or rep.channel<>c.Channel
or rep.Commodity<>ccsv.category)
and c.[Status] in (20,21)

-- Insert data
insert into Reporting.dbo.IR_WIP_Claims (ClaimID, TimeDiff, ClaimStatus, DateOfCompletion, Channel, Commodity)
select  c.claimid, 
		(ppd3.[dbo].[BusinessTimeDiffIncWE](c.createdate,case when c.[status]=20 then c.CompletedDate else c.CancelDate end)/60)/12,
		c.status,
		case when c.[status]=20 then c.CompletedDate else c.CancelDate end,
		c.Channel,
		ccsv.Category
from ppd3.dbo.claims c with(nolock)
join reporting.dbo.IP_WIP_ClaimCategory as ccsv on ccsv.claimid=c.claimid
where c.[status] in (20,21)
and not exists (select * from reporting.dbo.IR_WIP_Claims ir with(nolock) where ir.claimid=c.claimid)
GO
