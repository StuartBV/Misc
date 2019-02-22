SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClaimItems]
@id int
as
set nocount on
set dateformat dmy

select ID, ClaimID, AssetNo, isnull(GroupType,'') GroupType, isnull(MakeModel,'') MakeModel, isnull(Description,'') description,
case when FinalSettlement is null then 'Pending' else '£'+cast(FinalSettlement as varchar) end [FinalSettlement]
from fnol_claimItems
where claimId=@id
order by [id] desc

select sum(isnull(FinalSettlement,0)) TotalSettlement
from FNOL_ClaimItems
where claimid=@id

GO
