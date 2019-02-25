SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NoteDeleteAll]
@userID varchar(20),
@iCardsID varchar(50)
AS


insert into [Log] (iCardsID,UserID,Type,[Text],createdate) values (@iCardsID,@UserID,'8','ALL notes deleted',getdate())
delete from notes where iCardsID=@iCardsID
GO
