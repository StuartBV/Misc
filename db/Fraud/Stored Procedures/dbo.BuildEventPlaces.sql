SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildEventPlaces] 
@isUpdate smallint=0
as
set nocount on
declare @txt varchar(8000)

set @txt='<select id="fldEventPlace" class="FrmField">'
if (@isUpdate=0)
 begin
   set @txt=@txt+'<option value="-1" selected>Select:</option>'
 end

select @txt=@txt+'<option value="'+cast(code as varchar)+'">'+[description]+'</option>' 
from sysLookup where TableName = 'eventplace' 
order by flags

set @txt=@txt+'</select>'

select @txt

GO
