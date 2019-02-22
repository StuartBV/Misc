SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocScanDelete]
@userid varchar(20),
@scanID int=0

AS

set nocount on

update DocumentScanHeaders set cancelled=getdate()
where scanID=@scanID AND createdby=@userid
GO
