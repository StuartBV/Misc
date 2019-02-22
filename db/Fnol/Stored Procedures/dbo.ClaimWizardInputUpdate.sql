SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ClaimWizardInputUpdate] 
@claimid int, 
@wizardstatus tinyint
as
set nocount on

update fnol_claims
set wizardinputstatus = @wizardstatus,
status=case when @wizardstatus=5 then 'new' else null end
where claimid = @claimid
GO
