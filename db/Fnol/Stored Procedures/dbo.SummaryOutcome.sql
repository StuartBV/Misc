SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SummaryOutcome]
@claimid int
as

SET NOCOUNT ON
SET DATEFORMAT DMY
Set transaction isolation level read uncommitted 

SELECT 
sl.Description outcome,
sum(isnull(ci.FinalSettlement,0)) value
from dbo.syslookup sl
left join FNOL_ClaimItems ci on ci.claimid=@claimid and sl.code=ci.Outcome
where sl.TableName='FNOL - AssetOutcome' 
group by sl.Description

Set transaction isolation level read committed


GO
