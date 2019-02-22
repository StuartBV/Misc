SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocScanConfirmUpload]
@claimid int,
@DistID int=0
AS

-- Marks the Doc Scan as uploaded
update DocumentScanHeaders set uploaded=getdate() where claimID=@claimid and uploaded IS NULL and cancelled IS NULL


-- Logs the upload
--exec dbo.LogEntry @claimid,'PowerTransfer','27',0,'Scan Headers Uploaded'
GO
