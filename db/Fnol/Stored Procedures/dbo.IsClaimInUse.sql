SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[IsClaimInUse]
@claimid int
as

set nocount on 

SELECT case when HandlerInClaim is null then 0 else 1 end [claiminuse] 
from fnol_claims 
where claimid=@claimid

GO
