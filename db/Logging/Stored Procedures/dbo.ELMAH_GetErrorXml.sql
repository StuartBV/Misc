SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ELMAH_GetErrorXml]
@Application nvarchar(60),
@ErrorId uniqueidentifier
as
set nocount on

select AllXml
from ELMAH_Error
where ErrorId=@ErrorId and [Application]=@Application

GO
