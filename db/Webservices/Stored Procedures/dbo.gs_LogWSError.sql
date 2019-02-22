SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[gs_LogWSError] 
@ClaimID int,
@ErrorText varchar(8000)
AS

declare @Recipient varchar(200),@SenderEmail varchar(200),@SenderName varchar(100),@Subject varchar(100),@Body varchar(8000)

insert into Goldsmiths_Error_log(ClaimID,ErrorText)
values(@ClaimID,@ErrorText)


select @recipient='itsupport@powerplaydirect.co.uk',
		@senderemail='no-reply@powerplaydirect.co.uk',
		@sendername='Goldsmiths WebService',
		@subject='Code Error',
		@body='ClaimID= ' + cast(@claimid as varchar) +

@ErrorText

exec ppd3.dbo.SendMail @Recipient=@Recipient, @SenderEmail=@SenderEmail, @SenderName=@SenderName, @Subject=@Subject, @Body=@Body
GO
