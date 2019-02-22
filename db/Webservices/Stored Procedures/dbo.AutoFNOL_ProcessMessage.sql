SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[AutoFNOL_ProcessMessage]
@msgID int
AS

set nocount on
SET XACT_ABORT on
-- This SP is to be called periodically from a Job

declare 
@claimID int,
@IsError tinyint,
@ErrorMsg varchar(1000)

set @claimid=-1

if @msgID is not null
begin
	exec AutoFNOL_CheckLoadingTables @msgID, @IsError output, @ErrorMsg output
	if @IsError=0
	  begin
		exec AUTOFNOL_PushToPPD3 @InstructionId = @msgID
		select @claimID=cms_claimid from AUTOFNOL_MessageLog where id=@msgID
	  end
	else
		exec AutoFNOL_LogError @msgID,@ErrorMsg
end

select @claimID

GO
