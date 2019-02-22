SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetPolicyNoIDByServiceNo]
@ServiceNo nvarchar(50)
as
set nocount on 

select ID, PolicyNo
from fnol_policy
where ServiceNo=@ServiceNo
order by PolicyNo

GO
