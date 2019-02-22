SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
<SP>
	<Name>CopyNoteFromClaim</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080725</CreateDate>
	<Overview>Copys a note to a claim when a note is added to claim after its gone to Fraud</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[CopyNoteToClaim] 
@ClaimID int, 
@note text, 
@userid varchar(50),
@notetype tinyint=100,
@notereason tinyint=0
AS
declare
@ID int

BEGIN

set nocount ON

insert into Notes (ClaimID,Note,Createdate,createdby,NoteType, NoteReason) values(@ClaimID,@note,getdate(),@userid,@notetype,@notereason)

END
GO
