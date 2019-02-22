SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildWithdrawnReasons]
@IsUpdate tinyint=0
as
set nocount on
declare @txt varchar(8000)

set @txt='<select id="fldWithdrawnReason" class="FrmField">'
set @txt=@txt+'<option value="-1" selected>Select:</option>'
select @txt=@txt+'<option value="'+cast(code as varchar)+'">'+[description]+'</option>'
from sysLookup
where TableName='WithdrawnCode'
order by flags

set @txt=@txt+'</select>'

select @txt
GO
