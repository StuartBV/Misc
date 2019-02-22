SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildNoteReason] as
set nocount on
declare @txt varchar(8000)

set @txt='<select id="NoteReason" class="FrmField"><option noteflag="-1" value="-1" selected>Select</option>'

select @txt=@txt+'<option noteflag="'+cast(sl.flags as varchar)+'" value="'+cast(sl.code as varchar)+'">'+sl.[description]+'</option>' 
from syslookup sl
where sl.tablename = 'FNOL - NoteCode'
order by sl.flags desc, sl.[description]

set @txt=@txt+'</select>'

select @txt
GO
