SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Shaun Bradley
-- Create date: 20/11/2009
-- Description:	Provides Header for New Claims Wizard
-- =============================================
CREATE PROCEDURE [dbo].[GetClaimDetails_InputWizardHeader] 
	
	@ClaimID varchar(50)
	 
AS

set nocount on 
set transaction isolation level read uncommitted

	select (Result.Title + Result.Name + Result.ServiceNo +  Result.[Rank] + Result.PolicyNo) Header
	
	from(
			select		
			
			'<b>Title:</b> ' + coalesce(cl.Title,'?') Title,
			
			', <b>Name:</b> ' + coalesce(cl.Fname,'First Name ?') + ' ' + coalesce(cl.Sname,'SurName ?') Name,
			
			', <b>ServiceNo:</b> ' + coalesce(cl.serviceno,'?') ServiceNo,
			
			', <b>Rank:</b> ' + coalesce(rank.description,'?') [Rank],
			
			', <b>Policy No:</b> ' + coalesce(P.PolicyNo,'?') PolicyNo
			
			
			
			from FNOL_Claims cl
		
			JOIN FNOL_Policy P  ON cl.PolicyID=p.ID AND cl.claimid=@ClaimID	
			left join syslookup [rank]  on cl.[rank]=[rank].code and [rank].tablename='fnol - militaryrank'
		
		)Result
GO
