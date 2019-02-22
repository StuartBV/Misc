SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[AutoFnol_StoreCmsRef]
@claimid int,
@cmsref int,
@userid varchar(50)
as

declare @notetext varchar(500)

SET NOCOUNT ON
SET XACT_ABORT ON    
set transaction isolation level read uncommitted 

set @notetext='claim created on CMS via autofnol - CMS Ref '+cast(@cmsref as varchar)

update fnol_claims set CmsRef=@cmsref where claimid=@claimid

exec dbo.AddNoteToClaim 
	@ClaimID = @claimid, -- int
    @note = @notetext, -- text
    @userid = @userid
GO
