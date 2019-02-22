SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Shaun Bradley
-- Create date: 04/11/2009
-- Description:	Date for new-claim-from-policy Data Input Wizard Page 3
-- =============================================
CREATE PROCEDURE [dbo].[GetClaimDetails_InputWizardPage3] 
	
	@ClaimID VARCHAR(50)
	
as

set nocount on 
set transaction isolation level read uncommitted

	select cl.ClaimID,
		
		isnull(PoliceStation,'') PoliceStation,
		isnull(PoliceAddress,'') PoliceAddress,
		isnull(CrimeRef,'') CrimeRef,
		convert(varchar(12),DateNotified,103) DateNotified

	from FNOL_Claims cl

where cl.claimID = @ClaimID
GO
