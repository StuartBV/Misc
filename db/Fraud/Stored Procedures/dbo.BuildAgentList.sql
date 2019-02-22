SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildAgentList] 
@isUpdate smallint=0
as
set nocount on
set transaction isolation level read uncommitted

declare @txt varchar(8000)

set @txt='<select id="fldAgent" class="FrmField">'
if (@isUpdate=0)
 begin
   set @txt=@txt+'<option value="-1" selected>Select:</option>'
 end

select @txt=@txt+'<option value="'+r.userid+'">'+e.fname+' '+sname+'</option>' 
from Users r join ppd3.dbo.logon l  on l.userid=r.userid
join ppd3.dbo.employees e  on e.id=l.userfk
order by l.UserID

set @txt=@txt+'</select>'

select @txt
GO
