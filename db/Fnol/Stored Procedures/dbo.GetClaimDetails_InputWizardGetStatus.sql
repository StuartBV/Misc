SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Shaun Bradley
-- Create date: 20/11/2009
-- Description:	Gets the status of the wizard for the claim
-- =============================================
CREATE PROCEDURE [dbo].[GetClaimDetails_InputWizardGetStatus] 
	
	@ClaimID varchar(50)
	
AS

set nocount on
set transaction isolation level read uncommitted

	select WizardInputStatus
	from fnol_claims
	where claimID = @ClaimID
	
	
	
GO
