SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCardsDocumentScanConfirm]
@scanID int=0,
@userid varchar(20)=''
AS

if @userid=''
	return

update DocumentScans set printed=1,printedon=getdate() 
where 1=case when scanID=@scanID and printed=0 and createdby=@userid then 1 else --confirms only one scan header
		case when @scanID=0 and printed=0 and createdby=@userid then 1 else 0 end -- confirms all scan headers for said user
	end

--createdby=@userid and printed=0
--exec dbo.LogEntry 0,@userid,'27',0,'Scan Headers printed'
GO
