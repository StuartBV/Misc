SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
<SP>
	<Name>GetClaimLimits</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080502</CreateDate>
	<Overview>used to add limit details to claim after screening process</Overview>
	<Changes>
		<Change>
			<User>DerekF</User>
			<Date>18/9/2008</Date>
			<Comment>converted claimid to varchar for FNOL integration</Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[AddClaimLimits] 
@ClaimID int, 
@note varchar(200)=null, 
@userid varchar(50),
@notetype tinyint=100,
@notereason tinyint=0,
@risk smallint
AS
BEGIN
set nocount ON
UPDATE Fraud SET risk=@risk,AlteredBy=@userid,AlteredDate=GETDATE() WHERE ClaimID=@ClaimID
IF(@note IS NOT null)
  BEGIN	
	update claimproperties set limits=@note where claimid=@ClaimID
	set @note = 'Limits on claim are: '+@note
	--insert into Notes (ClaimID,Note,Createdate,createdby,NoteType, NoteReason) values(@ClaimID,@note,getdate(),@userid,@notetype,@notereason)
	exec addnotetoclaim @ClaimID = @ClaimID,@note = @note,@userid = @userid,@notetype = @notetype,@notereason = @notereason
		
  END
END
GO
