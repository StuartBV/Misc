SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetFinanceDetails]
@id INT
AS

SET NOCOUNT ON
SET DATEFORMAT dmy
set transaction isolation level read uncommitted

BEGIN

SELECT c.ClaimID,c.Estimate,c.Reserve,c.Recovery,c.Total_amount,c.Total_Cost,
		c.Total_Recovery,c.Final_Cost,isnull(c.Excess,0) Excess,isnull(s.Description,'') [ExcessMethod]
FROM fnol_claims c (nolock)
left join dbo.syslookup s on s.tablename='fnol - excessmethod' and s.code=c.ExcessMethod
WHERE claimId=@id

END
GO
