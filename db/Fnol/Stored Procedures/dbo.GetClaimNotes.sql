SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClaimNotes]
@claimid int,
@noteid int=null
as
set nocount on
set transaction isolation level read uncommitted
select [id],
replace(cast(note as varchar(8000)),char(10),'<br>') note,
[date],empname,alteredempname,altereddate,notetype,notereason,link,autonote from (
	select n.[id],
		case when n.notetype=20
			then left(cast(note as varchar(1000)),charindex(' http:/',cast(note as varchar(1000))))
			+ left(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))),
				len(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))))-1)
		else n.note end as note,
		n.createdby,convert(varchar(11),
		n.createdate,13)+', '+convert(char(5),
		n.createdate,8) as [date],
		case
			when lower(substring(n.createdby,1,3))='sys' then 'SYSTEM' 
			when l.userid is null then n.createdby
			else e.fname+' '+e.sname 
		end empname,
		ee.fname+' '+ee.sname alteredempname,
		convert(varchar(11),n.altereddate,13)+', '+convert(char(5),n.altereddate,8) as altereddate,
		n.notetype, sys.[description] as notereason,
		--case when n.notetype=20 then left(cast(note as varchar(1000)),charindex(' http:/',cast(note as varchar(1000))))	else n.note end as linknote,
		case when n.notetype=20 then 
			left(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))),
			len(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))))-1)
		else '' end as link,
		case when n.notetype=100 or notetype is null then 0 else 1 end as autonote
	from	fnol_notes n 
	left join ppd3.dbo.logon l on n.createdby=l.userid
	left join ppd3.dbo.logon ll on n.alteredby=ll.userid
	left join ppd3.dbo.employees e on e.[id]=l.userfk
	left join ppd3.dbo.employees ee on ee.[id]=ll.userfk
	left join ppd3.dbo.syslookup sys on sys.code=n.notereason and sys.tablename='fnol - notecode'
	where claimid=@claimid and n.id=case when @noteid is null then n.id else @noteid end
)x
order by [id] desc

GO
