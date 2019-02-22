SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[reports_getoptions] 
@reportID int
AS

SET NOCOUNT ON


SELECT Title ,Code ,Daterange ,Channel ,Team, Handler 
FROM reports 
WHERE id=@reportID



GO
