SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:	Shaun Bradley
-- Create date:	30/10/2009
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[GetClaimAddress] 
	
	@ClaimID VARCHAR(50)
AS


SET NOCOUNT ON
Set transaction isolation level read uncommitted

select cl.ClaimID,
isnull(cl.Address1,'') Address1,
isnull(cl.Address2,'') Address2,
isnull(cl.City,'') City,
isnull(cl.County,'') County,
isnull(cl.Postcode,'') Postcode,
isnull(cl.Country,'') Country

FROM FNOL_Claims cl


Set transaction isolation level read committed

GO
