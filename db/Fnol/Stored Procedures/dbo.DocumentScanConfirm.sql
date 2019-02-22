SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocumentScanConfirm]
@userid varchar(20)=''
AS

if @userid=''
	return

update DocumentScans set printed=1,printedon=getdate() where userid=@userid and printed=0
exec dbo.LogEntry 0,@userid,'27',0,'Scan Headers printed'

GO
