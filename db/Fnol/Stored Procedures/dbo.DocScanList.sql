SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocScanList] 
@claimid int,
@userid UserID
as
set nocount on
set transaction isolation level read uncommitted

-- Indicates whether a scanned header is queued for that claim
if exists (select * from DocumentScanHeaders where ClaimID=@claimid and createdby!=@userid and uploaded is null and cancelled is null)
	select createdby from DocumentScanHeaders where ClaimID=@claimid and createdby!=@userid and uploaded is null and cancelled is null
else if exists (select * from DocumentScanHeaders where ClaimID=@claimid and createdby=@userid and printed is not null and uploaded is null and cancelled is null)
	select createdby from DocumentScanHeaders where ClaimID=@claimid and createdby=@userid and printed is not null and uploaded is null and cancelled is null
else
	select '0' createdby

select flags, [description], extracode, extradescription
from ppd3.dbo.syslookup where tablename='DocScanType' and extracode=''
order by flags

GO
