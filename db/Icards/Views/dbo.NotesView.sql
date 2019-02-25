SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[NotesView] as
select 0 as ID,l.icardsid,convert(varchar(11),l.createdate,13)+', '+convert(char(5),l.createdate,8) as createdate,
e.fname+' '+sname name,'' as altereddate,'' as alteredby,s.[description] as reason,l.text as note,
'system' as createdby,l.createdate datesort
from [log] l left join syslookup s on l.[type] = s.code and s.tablename='LogType'
left join ppd3.dbo.logon lo on lo.userid = l.userid
left join ppd3.dbo.employees e on e.id = lo.userfk

union all

select n.Id,n.icardsid,convert(varchar(11),n.createdate,13)+', '+convert(char(5),n.createdate,8) as createdate,
e.fname+' '+e.sname name,convert(varchar(11),n.altereddate,13)+', '+convert(char(5),n.altereddate,8) as altereddate,
ea.fname+' '+ea.sname alteredby,sb.[description] as reason,n.note,'user' as createdby, n.createdate datesort
from notes n 
left join syslookup sa on n.notetype = sa.code and sa.tablename='NoteType'
left join syslookup sb on n.notereason = cast(sb.code as int) and sb.tablename='NoteReason'
left join ppd3.dbo.logon lo on n.createdby = lo.userid
left join ppd3.dbo.employees e on e.id = lo.userfk
left join ppd3.dbo.logon la on n.alteredby = la.userid
left join ppd3.dbo.employees ea on ea.id = la.userfk
GO
