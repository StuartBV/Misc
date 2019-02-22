SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Notes]
as
--UTC--
select ClaimID, Note, NoteType, NoteReason, [public], important, NoteCreateDate, NoteAlteredDate, CreateDate, CreatedBy, altereddate, alteredby
from PPD3.dbo.Notes
GO
