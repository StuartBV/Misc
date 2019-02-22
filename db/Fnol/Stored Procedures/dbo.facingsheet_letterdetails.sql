SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[facingsheet_letterdetails]
@claimid varchar(20)
as
declare
@claimref varchar(20),
@sql varchar(8000)

select @sql=""

set dateformat dmy
Set transaction isolation level read uncommitted

create table #tmp_questions (idnum int identity(1,1)primary key,claimid int, claimref varchar(10),answerid int,question varchar(200),answer varchar(200), comment varchar(1000))

insert into #tmp_questions ( claimid ,claimref, answerid ,question ,answer ,comment)

select 
c.claimid,
c.clientrefno,
a.answerID,
q.Question,
a.answer,
isnull(a.comments,'')
from Questions q
join answers a on q.QuestionID = a.QuestionID and a.ClaimID=@claimid
join fnol_claims c on c.claimid=a.claimid
order by q.Seq

select @sql="select "+@claimid+" [claimid], '"+claimref+"' [claimref]",@claimref=claimref FROM #tmp_questions where idnum=1

select @sql=@sql+",'"+question+"' [Q"+cast(idnum as varchar)+"],'"+answer+"' [A"+cast(idnum as varchar)+"],'"+comment+"' [C"+cast(idnum as varchar)+"]"
from #tmp_questions
order by idnum desc

exec(@sql)

exec GetLetterDetails @claimref = @claimref

drop table #tmp_questions

Set transaction isolation level read committed







GO
