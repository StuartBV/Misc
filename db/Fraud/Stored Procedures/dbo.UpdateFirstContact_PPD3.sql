SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[UpdateFirstContact_PPD3]
@claimid int
as
--UTC--
set nocount on 

update pc set pc.FirstContactDateUTC=dbo.PPGetdate(pc.TimeZoneID)
from
claims fc join fraud f on f.claimid=fc.claimid and f.OriginatingSys='PPD3'
join ppd3.dbo.claims pc on pc.claimid=fc.originclaimid
where fc.claimid=@claimid

update claims 
set FirstContactDate=getdate()
where OriginClaimID=@claimid
GO
