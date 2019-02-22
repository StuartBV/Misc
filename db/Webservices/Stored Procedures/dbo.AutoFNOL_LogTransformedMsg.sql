SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[AutoFNOL_LogTransformedMsg] 
@msgid int,
@xml text
as

set nocount on

update AUTOFNOL_MessageLog
set transformed_message=@xml
where id=@msgid
GO
