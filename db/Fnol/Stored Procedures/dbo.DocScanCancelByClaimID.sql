SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocScanCancelByClaimID] 
@claimid int,
@userid varchar(20)
AS

set transaction isolation level read uncommitted

declare @scanID int

select @scanID=isnull(max(scanID),0) from DocumentScanHeaders 
where claimid=@claimid and uploaded is null and cancelled is null

--select @scanID

if @scanID>0
begin tran
	update DocumentScanHeaders set cancelled=getdate()
	where scanID=@scanID

	-- Logs the upload
	--exec dbo.LogEntry @claimid,@userid,'27',0,'Scan Header Cancelled'

commit tran
GO
