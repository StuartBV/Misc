SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

-- =============================================
-- Author:		<Derek Francis>
-- Create date: <24 Oct 2008>
-- Description:	<procedure used to return all Diary events>

-- =============================================
CREATE PROCEDURE [dbo].[DiaryEvents] AS

BEGIN
	set QUOTED_IDENTIFIER Off
	Set transaction isolation level read uncommitted
	SET NOCOUNT ON
	set dateformat dmy



	select
	c.claimid,p.PolicyNo,ClientRefNo,convert(varchar(12),incidentdate,103) IncidentDate,
	d.Description Event,c.status,c.Title+' '+c.Fname+' '+c.sname customer,CONVERT(VARCHAR(12),c.diaryeventdate,13) due,
	DATEDIFF(d,CONVERT(VARCHAR(12),GETDATE(),13),CONVERT(VARCHAR(12),c.diaryeventdate,13) ) daysleft,
	case when c.[28daylettersent] is not null then 'SENT' else '' end [28daylettersent]
	FROM fnol_claims c
	JOIN FNOL_Policy p  ON c.PolicyID=p.ID
	JOIN DiaryCodes d ON d.Code=c.Status
	where c.diaryeventdate is not null
	ORDER BY 9



	--unique values to be used for status filter
	select 1 seq,'Show All' description,'All' status
	union all
	select seq,description+' ('+cast(total as varchar)+')' as description,status
	from (
		select 2 seq, d.Description,c.status, count(*) total
		FROM fnol_claims c 
		JOIN DiaryCodes d ON d.Code=c.Status
		where c.diaryeventdate is not null
		group by d.Description,c.status
	)x
	order by seq,Description


END


Set transaction isolation level read committed

GO
