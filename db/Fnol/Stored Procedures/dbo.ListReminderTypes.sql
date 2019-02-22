SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ListReminderTypes]
as

DECLARE
@list VARCHAR(8000)

SET NOCOUNT ON
SET @list='' 

SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+code+':'+Description
FROM dbo.ReminderTypes
order by Description

SELECT '{'+@list+'}'
GO
