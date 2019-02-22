SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AddNoteToClaim] 
@ClaimID int, 
@note text, 
@userid varchar(50),
@notetype tinyint=100,
@notereason tinyint=0,
@InsNoteID int=0 output
AS
declare
@ID int

BEGIN

set nocount ON

insert into FNOL_Notes (ClaimID,Note,Createdate,createdby,NoteType, NoteReason) 
values(@ClaimID,@note,getdate(),@userid,@notetype,@notereason)

SET @InsNoteID=SCOPE_IDENTITY()

/* set status of claim if flag on notereason is set to 1 */
if exists(SELECT * FROM dbo.sysLookup where TableName like 'FNOL - NoteCode' and code=@notereason and Flags=1)
begin 
	update c 
	set c.status=s.extracode 
	FROM dbo.FNOL_Claims c 
	join dbo.syslookup s 
		on s.TableName='FNOL - NoteCode' 
		and s.code=@notereason 
		and s.Flags=1
	where c.ClaimID=@ClaimID
end

EXEC GetClaimNotes @ClaimID, @InsNoteID

END
GO
