SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCardsDocumentScanDelete]
@scanID int=0

AS

set nocount on

update DocumentScans set deleted=1
where scanID=@scanID
GO
