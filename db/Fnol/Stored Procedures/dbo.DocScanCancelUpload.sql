SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocScanCancelUpload]
@claimid int,
@DistID int=0
AS

-- Marks the Doc Scan as cancelled
update DocumentScanHeaders set cancelled=getdate() where claimID=@claimid and uploaded is null and cancelled is null

-- Logs the upload
--exec dbo.LogEntry @claimid,'PowerTransfer','27',0,'Scan Headers Cancelled (PowerTransfer)'
GO
