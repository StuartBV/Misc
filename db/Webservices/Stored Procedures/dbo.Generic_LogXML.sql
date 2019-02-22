SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[Generic_LogXML]
@claimid int=0,
@SupplierID int=0,
@MessageType int=-1,
@Direction varchar(3)='',
@XML varchar(8000)='',
@XMLResponse varchar(8000)='',
@Status tinyint=0
AS
declare @Recipient varchar(200),@SenderEmail varchar(200),@SenderName varchar(100),@Subject varchar(100),@Body varchar(8000)
declare @servertype varchar(50)
select @servertype=ppd3.dbo.ServerType()

insert into Generic_XML_Log (ClaimID, SupplierID, Direction, MsgType, [XML], XMLResponse, Status,createdate)
Values (@Claimid, @SupplierID, @Direction, @MessageType, @XML, @XMLResponse, @Status,getdate())

if @status=0
begin

	select @recipient='itsupport@powerplaydirect.co.uk',
		@senderemail='no-reply@powerplaydirect.co.uk',
		@sendername='Generic WebService',
		@subject=@servertype + ' - XML Error',
		@body='Claimid = ' + cast(@claimid as varchar) + '
SupplierID = ' + cast(@supplierid as varchar) + '
MessageType = ' + cast(@messagetype as varchar) + '
Direction = ' + cast(@direction as varchar) + '
XML Response 
' + @XMLResponse + '

XML Outbound
' + @XML

	exec ppd3.dbo.SendMail	@Recipient=@Recipient, @SenderEmail=@SenderEmail, @SenderName=@SenderName, @Subject=@Subject, @Body=@Body

end
GO
