SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[QA_GetList]
@answerid int=0,
@team int,
@accesslevel int=2
as

set nocount on
set transaction isolation level read uncommitted


SELECT q.id [questionid],q.Question [question], a.id [answerid],a.name [answer],
	isnull(a.code,'') [result],
	q2.id [nextquestionid]
FROM dbo.Status_Questions q 
join dbo.Status_Answers a on a.Questiontid=q.id 
left join dbo.Status_Questions q2 on q2.answerid=a.id
--left join dbo.TeamLookups t on t.answerid=a.id 
where q.answerid=@answerid
and a.name=case when @answerid=0 and @accesslevel=2 then 'Change Status' else a.name end
order by a.Sequence


set transaction isolation level read committed
GO
