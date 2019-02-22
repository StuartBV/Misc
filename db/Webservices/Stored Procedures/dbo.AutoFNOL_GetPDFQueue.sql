SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AutoFNOL_GetPDFQueue]
as
set nocount on

select top 10 ID,transformed_message,CMS_ClaimID
from AUTOFNOL_MessageLog
where status='Uploaded'
and pushedtoppd3 is not null 
and CMS_ClaimID>0
order by id
GO
