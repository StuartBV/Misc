SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[reports_list] 
AS

SET NOCOUNT ON

--list of reports
SELECT 1 AS seq,'All' as Title,'All' as id
UNION all
SELECT 2 AS seq,Title,cast(id as varchar)
FROM reports 
WHERE [enabled]=1



GO
