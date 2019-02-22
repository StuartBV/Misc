SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReminderCodes] as
SELECT ID,
	   TableName,
	   Code,
	   Description,
	   CAST(ExtraCode AS INT) flags,
	   ExtraDescription
FROM syslookup 
WHERE tablename = 'fraudstatus'
AND ExtraDescription='reminderevent'
GO
