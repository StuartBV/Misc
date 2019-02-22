SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClaimNotes]
@ClaimID varchar(20),
@NoteID int=null,
@application varchar(50),
@rows tinyint=0,
@showall tinyint=1
as
set quoted_identifier off
set nocount on
declare @sql nvarchar(4000),@ID varchar(100),@OriginClaimID int,@claimRef varchar(50),@applicationtouse varchar(50)


select @ID=case when @NoteID is not null then cast(@NoteID as varchar) else 'n.id' end
select @OriginClaimID=originclaimid,@claimRef=ClaimNo from claims where claimid=@ClaimID

if @application='FNOL' 
	begin set @applicationtouse='fnol.dbo.fnol_' end
else
	begin set @applicationtouse=@application+'.dbo.' end

if @rows>0
begin set @sql="select top "+cast(@rows as varchar)+" " end 
else
begin set @sql="select " end 

set @sql=@sql+" [ID], replace(cast(note as varchar(8000)),char(10),'<br>') note,
[date],EmpName,AlteredEmpName,alteredDate,NoteType,notereason,link,autonote,'"+@claimRef+"' [claimref] from(
select N.[ID], case when n.notetype=20
		then left(cast(note as varchar(1000)),charindex(' http:/',cast(note as varchar(1000))))
		+ left(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))),
			len(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))))-1)
	else N.Note end as note,
	N.CreatedBy,convert(varchar(11),
	N.createdate,13)+', '+convert(char(5),
	N.createdate,8) as date,
	case when lower(l.userID)='sys' then 'SYSTEM' 
	when l.userId is null then n.createdby
	else E.Fname+' '+E.Sname 
	end EmpName,
	EE.Fname+' '+EE.Sname AlteredEmpName,
	convert(varchar(11),N.AlteredDate,13)+', '+convert(char(5),N.AlteredDate,8) as altereddate,
	N.NoteType,
	sys.description as notereason,
	case when n.notetype=20 then 
		left(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))),
		len(right(cast(note as varchar(1000)),len(cast(note as varchar(1000)))-charindex(' http:/',cast(note as varchar(1000)))))-1)
	else '' end as link,
	case when n.notetype=100 or notetype is null then 0 else 1 end as autonote
from "+@applicationtouse+"Notes N 
left join ppd3.dbo.Logon L on N.createdby=L.UserID
left join ppd3.dbo.Logon LL on N.AlteredBy=LL.UserID
left join ppd3.dbo.Employees E on E.[ID]=L.UserFK
left join ppd3.dbo.Employees EE on EE.[ID]=LL.UserFK
left join ppd3.dbo.syslookup sys on sys.code=n.notereason and sys.tablename='"
+ case when @application='FNOL' then 'Fnol - NoteCode' else 'NoteReason' end + "'
where ClaimID="+cast(@OriginClaimID as varchar)+" and n.id="+@ID

if @showall=0
begin set @sql=@sql+" and isnull(n.notetype,100)=100" end 

set @sql=@sql+")x order by [id] desc "

exec sp_executesql @sql

GO
