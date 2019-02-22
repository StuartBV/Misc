SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[CMS_ClaimsInTS] as
select c.OriginClaimID 
from claims c join fraud f on c.ClaimID = f.ClaimID
where f.OriginatingSys='ppd3'


GO
