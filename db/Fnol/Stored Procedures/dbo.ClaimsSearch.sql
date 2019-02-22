SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Derek Francis>
-- Create date: <14 Aug 2008>
-- Description:	<procedure used to return all claims for a given policyID>
-- =============================================
CREATE PROCEDURE [dbo].[ClaimsSearch]
	-- Add the parameters for the stored procedure here
	@id int
as

set transaction isolation level read uncommitted

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set QUOTED_IDENTIFIER Off
	SET NOCOUNT ON;
	select
	claimid,convert(varchar(12),incidentdate,103) IncidentDate,ClientRefNo,Description,
	case when datefinalised is null then 'O' else 'F' end Status
	FROM fnol_claims c 
	WHERE c.policyid=@id
	order by cast(incidentdate as datetime) desc
	
END
GO
