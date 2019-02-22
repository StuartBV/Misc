SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AddNoteToClaim] 
@ClaimID int, 
@note text, 
@userid UserID,
@notetype tinyint=100,
@notereason tinyint=0
as

set nocount on

declare @ID int,@OriginClaimID int,@application varchar(50),@InsNoteID int

select @OriginClaimID=originclaimid from claims where claimid=@ClaimID
select @application=OriginatingSys from Fraud where ClaimID=@ClaimID

if (@application='PPD3') 
begin
	exec ppd3.dbo.NoteCreate  @OriginClaimID,@note,@userid,@notetype,@notereason,@InsNoteID output
	exec GetClaimNotes @ClaimID, @InsNoteID, @application
end
else if (@application='FNOL')
begin
	-- Translate NoteReason parameter to Fnol NoteCode / Default to General Note (1) if not found
	select @notereason=isnull((select sys.extracode from ppd3.dbo.syslookup sys where sys.TableName='PPD3NoteReason_to_FNOLNoteReason' and sys.code=@notereason),1)
	
	exec fnol.dbo.AddNoteToClaim @OriginClaimID,@note,@userid,@notetype,@notereason,@InsNoteID output	
end


GO
