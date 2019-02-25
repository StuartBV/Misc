SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[NoteDelete]
@NoteID int,
@iCardsID varchar(50),
@userID UserID
as
set nocount on
declare @txt varchar(100)

if exists (select * from notes where [ID]=@NoteID and notetype=1) and @userID not in ('stu','sys')
begin
	insert into [log] (iCardsID,UserID,[type],[text],createdate)
	values (@iCardsID,@UserID,'8','Delete attempted for Customer Contact Audit Note',getdate())
end
else
begin
	begin tran
		select @txt='Note deleted: ' + cast(note as varchar(20)) + '...' from notes where [id]=@noteID
		insert into [log] (iCardsID,UserID,[type],[text],createdate)
		values (@iCardsID,@UserID,'8',@txt,getdate())
		delete from notes where [id]=@NoteID
	commit tran
end
GO
