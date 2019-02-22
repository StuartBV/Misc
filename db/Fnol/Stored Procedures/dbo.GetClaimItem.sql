SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetClaimItem]
@id INT
AS

SET NOCOUNT ON
SET DATEFORMAT dmy
set transaction isolation level read uncommitted

BEGIN

SELECT ci.ID, ci.ClaimID, ci.AssetNo, ci.MakeModel,
        ci.Description, ci.ItemValue, ci.Age, ci.Category1, ci.Category2, 
        isnull(ci.GroupType,'') GroupType, 
        isnull(s1.Description,'') Substantiation,
        isnull(s2.Description,'') ValidationType, 
        ProposedSettlement, Deduction, 
        isnull(s4.Description,'') Outcome, 
        isnull(s3.Description,'') SettlementType,
        ci.FinalSettlement,
        isnull(s5.Description,'No') ExcessTaken
FROM fnol_claimItems ci (nolock)
left join dbo.syslookup s1 on s1.TableName='FNOL - YesNo' and s1.code=ci.Substantiation
left join dbo.syslookup s2 on s2.TableName='FNOL - ValidationType' and s2.code=ci.ValidationType
left join dbo.syslookup s3 on s3.TableName='FNOL - SettlementType' and s3.code=ci.SettlementType
left join dbo.syslookup s4 on s4.TableName='FNOL - AssetOutcome' and s4.code=ci.Outcome
left join dbo.syslookup s5 on s5.TableName='FNOL - YesNo' and s5.code=ci.ExcessTaken
WHERE ci.Id=@id

END
GO
