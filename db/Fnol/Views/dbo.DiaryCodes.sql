SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[DiaryCodes] as
SELECT ID,
	   TableName,
	   Code,
	   Description,
	   Flags,
	   ExtraDescription
FROM syslookup 
WHERE tablename = 'fnol - statuscode'
AND ExtraDescription='diary'
GO
