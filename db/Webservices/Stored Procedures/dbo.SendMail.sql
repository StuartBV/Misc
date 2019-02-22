SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[SendMail]
@Recipient varchar(200),
@SenderEmail varchar(200),
@SenderName varchar(100),
@Subject varchar(100),
@Body varchar(8000),
@attach varchar(200)='',
@Bcc varchar(200)=''
AS

set nocount on

exec ppd3.dbo.SendMailExecute @Recipient = @recipient,
    @SenderEmail = @senderemail,
    @SenderName = @sendername,
    @Subject = @subject,
    @Body = @body,
    @attach = @attach,
    @Bcc = @bcc
  
GO
