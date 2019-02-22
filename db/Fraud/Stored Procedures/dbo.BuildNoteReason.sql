SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildNoteReason] as
set nocount on
declare @txt varchar(8000)

set @txt='<select id="NoteReason" class="FrmField"><option value="-1" selected>Select:</option>'

select @txt=@txt + '<option value="' + cast(code as varchar) + '">' + [description] + '</option>' 
from ppd3.dbo.syslookup 
where tablename = 'notereason'
order by extracode

set @txt=@txt + '</select>'

select @txt
GO
