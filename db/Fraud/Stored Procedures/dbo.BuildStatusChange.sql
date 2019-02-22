SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildStatusChange] 
@isUpdate smallint=0,
@AccessLevel smallint=2,
@Team varchar(50)=''
as
set nocount on
declare @txt varchar(8000)

set @txt='<select id="fldStatusChange" class="FrmField" onchange="StatusCheck()">'
if (@isUpdate=0)
 begin
   set @txt=@txt+'<option value="-1" selected>Select:</option>'
 end
select @txt=@txt+'<option value="'+cast(s.code as varchar)+'">'+s.[description]+'</option>'
from syslookup s2
join sysLookup s on s.TableName='fraudstatus' and s2.TableName='team'
left join TeamLookups l on s.TableName=l.[type] and s.code=l.code and l.Team=s2.Code
where (
	cast(s.code as int) between 1 and 98 or s.code = case when @AccessLevel=1 then '99' else '100' end ) -- only include closed status if manager else include 'refer to manager' option
and s2.[description]=@Team
and (l.id is not null or not exists(select * from TeamLookups t where t.Team=s2.code) )
order by s.flags
set @txt=@txt+'</select>'
select @txt

GO
