SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BuildCloseReasons] 
@Team varchar(50)=''
as
set nocount on
declare @txt varchar(8000)
set @txt='<select id="fldCloseReason" class="FrmField" onchange="WithdrawnCheck()">'
set @txt=@txt+'<option value="-1" selected>Select:</option>'
select @txt=@txt+'<option value="'+cast(x.code as varchar)+'">'+x.[description]+'</option>'
from (
	select distinct s.code,s.[description],s.flags
	from sysLookup s
	left join TeamLookups l on s.TableName=l.[type] and s.code=l.code 
	left join sysLookup s2 on s2.tablename='team' and s2.Code=l.team and s2.[description]=@Team
	where s.tablename = 'CloseReason' and s.extracode=1
) x
order by x.flags
set @txt=@txt+'</select>'
select @txt
GO
