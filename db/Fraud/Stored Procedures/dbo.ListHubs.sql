SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ListHubs]
AS

SET NOCOUNT on

SELECT description,code
FROM sysLookup s
WHERE s.TableName='team'
AND code<>'0'
ORDER BY flags
GO
