SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NoteCreate] 
@iCardsID varchar(50), 
@note varchar(8000), 
@userid varchar(50),
@notetype tinyint=null,
@notereason tinyint=0
AS
set nocount on
insert into Notes (iCardsID,Note,Createdate,createdby,NoteType, NoteReason) values(@iCardsID,@note,getdate(),@userid,@notetype,@notereason)
GO
