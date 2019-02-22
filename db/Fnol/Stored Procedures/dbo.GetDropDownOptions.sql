SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDropDownOptions]
@param VARCHAR(100)
as
DECLARE
@list VARCHAR(8000)

SET NOCOUNT ON
SET @list=''

SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+'"'+code+'":"'+left(description,36)	+'"'
FROM syslookup
WHERE TableName=@param
order by Flags desc, Description

SELECT '{'+@list+'}'


GO
