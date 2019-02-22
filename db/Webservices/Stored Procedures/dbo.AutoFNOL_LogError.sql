SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AutoFNOL_LogError]
@InstructionID int,
@ErrorMsg varchar(1000)
as
declare @text varchar(8000)
declare @servertype varchar(50), @subject varchar(100)

set nocount on

select @servertype=ppd3.dbo.ServerType()
select @subject=@servertype + ' - AutoFNOL PushToPPD3 Error'
insert into Logging.dbo.log4net (Date,Thread,[level],logger,[message],exception,Portal,IpAddress,UserName) 
select getdate(),1,'ERROR','Message: '+cast(@InstructionID as varchar)+', AutoFNOL - PushToPPD3',@ErrorMsg,'','AutoFNOL','',''

update webservices.dbo.AUTOFNOL_MessageLog set [status]='ERROR' where id=@InstructionID

set @text='Message: '+cast(@InstructionID as varchar)+', AutoFNOL - PushToPPD3. Reason for Error is: '+@ErrorMsg

exec ppd3.dbo.SendMail @Recipient='itsupport@powerplaydirect.co.uk',@SenderEmail='noreply@powerplaydirect.co.uk',@SenderName='AutoFNOL Webservice',@Subject=@subject, @Body=@text
GO
