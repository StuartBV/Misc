SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[XXXIR_WIP_Incremental_Population]
AS
truncate table ppd3.dbo.MPClaimid

insert into ppd3.dbo.MPClaimid
select top 1000 c.Claimid
from ppd3.dbo.Claims c with(nolock)
join ppd3.dbo.ClaimProperties as cp on cp.claimid=c.claimid
where cp.ClaimLifespan is null
and ((c.Status=20 and c.CompletedDate is not null) or
	(c.Status=21 and c.CancelDate is not null))
	and cp.ClaimLifespan is null


update cp set cp.ClaimLifespan=ppd3.dbo.BusinessTimeDiffIncWe(c.createdate,case when c.status=20 then c.CompletedDate else c.CancelDate end)
from ppd3.dbo.Claims c with(nolock)
join ppd3.dbo.mpclaimid m on m.claimid=c.claimid
join ppd3.dbo.ClaimProperties cp on cp.claimid=c.claimid
GO
