SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
<SP>
	<Name>ChangeStatus</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080506</CreateDate>
	<Overview>called to change the status of a claim</Overview>
	<Changes>
		<Change>
			<User>DerekF</User>
			<Date>18/9/2008</Date>
			<Comment>converted claimid to varchar for FNOL integration</Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[ChangeStatus] 
@claimID int,
@Status INT,
@note varchar(8000),
@userid VARCHAR(50),
@reason varchar(10)='',
@subcategory varchar(10)='',
@cancel tinyint
AS
Declare
@fin varchar(15),
@Tier SMALLINT
SET NOCOUNT ON
select @fin=fin,@Tier=currenttier from fraud where claimid=@claimID
BEGIN tran
	if (@Status=99) -- closed flag
	 begin
	   EXEC CloseFraud @FIN = @fin, @UserID = @userid, @Decision = @reason, @SubCategory = @subcategory, @cancelCMS = @cancel
	   EXEC AddNoteToClaim @ClaimID = @claimID,@note = @note,@userid = @userid,@notetype = 0,@notereason = 0 
	   exec LogEvent @fin,@userid,null,@Tier,@Status,0
	 end
	ELSE if (@Status=9) -- escalate to Tier2 flag
	 begin
	   UPDATE fraud SET Status=1,currenttier=2,dateclosed=null,AlteredDate=GETDATE(),AlteredBy=@userid WHERE ClaimID=@claimID	
	   EXEC AddNoteToClaim @ClaimID = @claimID,@note = 'Claim escalated to Tier 2 for further investigation',@userid = @userid,@notetype = 0,@notereason = 0 
	   exec LogEvent @fin,@userid,null,2,1,0
	 END
	ELSE if (@Status=20) -- escalate to Tier3 flag
	 begin
	   UPDATE fraud SET Status=1,currenttier=3,dateclosed=null,AlteredDate=GETDATE(),AlteredBy=@userid WHERE ClaimID=@claimID	
	   EXEC AddNoteToClaim @ClaimID = @claimID,@note = 'Claim escalated to Tier 3 for further investigation',@userid = @userid,@notetype = 0,@notereason = 0 
	   exec LogEvent @fin,@userid,null,3,1,0
	 END
	ELSE if (@Status=21) -- escalate to Tier1 flag
	 begin
	   UPDATE fraud SET currenttier=1,dateclosed=null,AlteredDate=GETDATE(),AlteredBy=@userid WHERE ClaimID=@claimID	
	   EXEC AddNoteToClaim @ClaimID = @claimID,@note = 'Claim moved to Tier 1',@userid = @userid,@notetype = 0,@notereason = 0 
	   exec LogEvent @fin,@userid,null,1,1,0
	 END
	ELSE
	 begin
	   
	   select @note='Claim status changed to '+description+','+ char(10)+ 'reason: '+@note
	   from sysLookup where TableName='fraudstatus' and code=@status
	   
	   UPDATE fraud SET Status=@Status,dateclosed=null,AlteredDate=GETDATE(),AlteredBy=@userid WHERE ClaimID=@claimID	
	   EXEC AddNoteToClaim @ClaimID = @claimID,@note = @note,@userid = @userid,@notetype = 0,@notereason = 0 
	   exec LogEvent @fin,@userid,null,@Tier,@Status,0
	 end
commit




GO
