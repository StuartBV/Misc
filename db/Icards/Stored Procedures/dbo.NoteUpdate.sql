SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NoteUpdate]
@NoteID int,
@txt text,
@UserID varchar(50)

 AS
set nocount on

update notes set note=@txt, AlteredDate=getdate(),AlteredBy=@UserID where [ID]=@NoteID
GO
