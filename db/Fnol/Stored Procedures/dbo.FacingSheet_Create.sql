SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[FacingSheet_Create]
@claimid int
as
declare
@lossdate varchar(3),
@prevclaims varchar(3),
@prevclaimsyear varchar(3),
@prevclaimscause varchar(3),
@policycancelled varchar(3),
@policyrenewal varchar(3),
@claimsrepudiated varchar(3)

set dateformat dmy
Set transaction isolation level read uncommitted

if not exists (select * from answers where claimid=@claimid)
begin

	/* calcualte answers to simple questions */
	select
	@lossdate=case when datediff(d,p.InceptionDate,c.IncidentDate)<90 then 'Yes' else 'No' end,
	@prevclaims=case when (select count(*) from fnol_claims where ServiceNo=c.ServiceNo and ClientRefNo<>c.ClientRefNo)>0 then 'Yes' else 'No' end,
	@prevclaimsyear=case when (select count(*) from fnol_claims where ServiceNo=c.ServiceNo and ClientRefNo<>c.ClientRefNo and year(CreatedDate)=c.CreatedDate)>0 then 'Yes' else 'No' end,
	@prevclaimscause=case when (select count(*) from fnol_claims where ServiceNo=c.ServiceNo and ClientRefNo<>c.ClientRefNo and cause=c.cause)>0 then 'Yes' else 'No' end,
	@policycancelled=case when c.Status='CANC' and c.DateFinalised<c.IncidentDate then 'Yes' else 'No' end,
	@policyrenewal=case when datediff(d,c.incidentDate, dateadd(d,365,p.InceptionDate))<15 then 'Yes' else 'No' end,
	@claimsrepudiated=case when (select count(*) from fnol_claims where ServiceNo=c.ServiceNo and ClientRefNo<>c.ClientRefNo and status='REPUD' and DateFinalised>p.InceptionDate)>0 then 'Yes' else 'No' end
	from FNOL_Policy p 
	join fnol_claims c on p.id=c.PolicyID
	where c.claimid=@claimid


	/* store answers */
	insert into Answers ( QuestionID, ClaimID, Answer, CreateDate, CreatedBy )
	select 1,@claimid,@lossdate, getdate(),'SYS'
	union all
	select 3,@claimid,@prevclaims, getdate(),'SYS'
	union all
	select 4,@claimid,@prevclaimsyear, getdate(),'SYS'
	union all
	select 5,@claimid,@prevclaimscause, getdate(),'SYS'
	union all
	select 7,@claimid,@policycancelled, getdate(),'SYS'
	union all
	select 8,@claimid,@policyrenewal, getdate(),'SYS'
	union all
	select 9,@claimid,@claimsrepudiated, getdate(),'SYS'
	union all
	select QuestionID,@claimid,'No', getdate(),'SYS' from Questions where QuestionaireID=1 and QuestionID  not in (1,3,4,5,7,8,9)

end

/* select all questions and any answers */
select 
a.answerID,
q.Question,
isnull(case when a.Answer='Yes' then 'checked' when a.answer='No' then '' end,'') [answer],
isnull(a.comments,'') [comment]
from Questions q
join answers a on q.QuestionID = a.QuestionID and a.ClaimID=@claimid
order by q.Seq


Set transaction isolation level read committed






GO
