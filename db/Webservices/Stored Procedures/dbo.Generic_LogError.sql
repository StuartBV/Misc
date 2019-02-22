SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Generic_LogError]
@claimid int=0,
@SupplierID int=0,
@MessageType int=-1,
@ErrorMsg varchar(8000)=''
AS

declare @Recipient varchar(200),@SenderEmail varchar(200),@SenderName varchar(100),@Subject varchar(100),@Body varchar(8000)
declare @servertype varchar(50)
select @servertype=ppd3.dbo.ServerType()

insert into [Generic_XML_Error_Log] (ClaimID, SupplierID, MessageType, ErrorMsg)
values (@claimid, @SupplierID, @MessageType, @ErrorMsg)

select @recipient='itsupport@powerplaydirect.co.uk',
		@senderemail='no-reply@powerplaydirect.co.uk',
		@sendername='Generic WebService',
		@subject=@servertype + ' - Code Error',
		@body='ClaimID= ' + cast(@claimid as varchar) +'
SupplierID = ' + cast(@SupplierID as varchar) +'
MessageType = ' + cast(@MessageType as varchar) + '
' + @ErrorMsg

exec ppd3.dbo.SendMail	@Recipient=@Recipient, @SenderEmail=@SenderEmail, @SenderName=@SenderName, @Subject=@Subject, @Body=@Body
GO
