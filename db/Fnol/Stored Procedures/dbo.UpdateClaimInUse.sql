SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[UpdateClaimInUse]
@exit tinyint=0,
@userid varchar(50),
@claimid int
as

set nocount on 

update fnol_claims 
set HandlerInClaim=case when @exit=1 then null else @userid end 
where ClaimID=@claimid

GO
