SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AutoFNOL_LogPDF]
@messageid int
as

set nocount on

update autofnol_messagelog
set PDF_Created=getdate()
where ID=@messageid
GO
