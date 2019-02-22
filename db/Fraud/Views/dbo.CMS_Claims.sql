SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CMS_Claims] as
select c.OriginClaimID ClaimId
from Claims c join Fraud f on f.ClaimID=c.ClaimID and f.OriginatingSys='ppd3'
GO
