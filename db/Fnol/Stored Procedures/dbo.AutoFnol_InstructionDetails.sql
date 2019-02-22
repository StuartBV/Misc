SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[AutoFnol_InstructionDetails]
@claimid int,
@assets varchar(1000)
as

declare @sep char(1)

create table #assets(id int)

set @sep=','

SET NOCOUNT ON
SET XACT_ABORT ON    
set transaction isolation level read uncommitted 

select 
isnull(P.PolicyNo,'') [InsurancePolicyNo],
isnull(cl.ClientRefNo,'') [UniqueRef],
isnull(cl.ClientRefNo,'') [InsuranceClaimNo],
isnull(convert(varchar(12),cl.IncidentDate,103),'') [IncidentDate],
isnull(convert(varchar(12),cl.DateNotified,103),'') [ClaimReceivedDate],
isnull(cl.excess,0) [Excess],
isnull(cause.description,'') [CauseOfClaimNotes],
isnull(CrimeRef,'') [CrimeRefNumber],
isnull(convert(varchar(12),p.InceptionDate,103),'') [PolicyInceptionDate],
isnull(cl.Title,'') [Title],
isnull(cl.Fname,'') [Fname],
isnull(cl.Sname,'') [Lname],
isnull(cl.Address1,'') [Address1],
isnull(cl.Address2,'') [Address2],
isnull(cl.City,'') [Town],
isnull(cl.County,'') [County],
isnull(cl.Postcode,'') [Postcode],
isnull(cl.Country,'') [Country],
isnull(cl.Hphone,'') [Hphone],
isnull(cl.Wphone,'') [Wphone],
isnull(cl.Mphone,'') [Mphone],
isnull(cl.Email,'') [Email],
isnull(cl.description,'') [OtherInfo]
FROM FNOL_Claims cl  
JOIN FNOL_Policy P  ON cl.PolicyID=p.ID and cl.claimid=@ClaimID
join fnol_companies co  on p.companyid=co.id 
left join syslookup cause  on cl.cause=cause.code and cause.tablename='fnol - cause';


/* need to select assets here */
WITH rowids(id, start, stop) AS (
  SELECT 1, 1, CHARINDEX(@sep, @assets)
  UNION ALL
  SELECT id + 1, stop + 1, CHARINDEX(@sep, @assets, stop + 1)
  FROM rowids
  WHERE stop > 0
)
insert into #assets ( id )
SELECT SUBSTRING(@assets, start, CASE WHEN stop > 0 THEN stop-start ELSE 512 END) AS s
FROM rowids


SELECT  sl.code [CatId], ci.GroupType+' - '+ci.MakeModel+' - '+ci.Description [Description], ci.Age, ci.ItemValue [Value]
FROM dbo.FNOL_ClaimItems ci
join #assets a on a.id=ci.ID and ci.ClaimID=@claimid
join dbo.syslookup sl on sl.TableName='GroupMap' and sl.Description=ci.GroupType

drop table #assets



GO
