SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_Module_HubEmail_SendEmail]
@claimid int,
@subject varchar(50),
@senderemail varchar(50),
@body varchar(8000),
@hash varchar(36)
as
set nocount on
declare @hubemail varchar(100), @sendername varchar(100), @emailsubject varchar(200), @environment varchar(20), @cc varchar(100)

select @cc=@senderemail, @emailsubject='CLAIMVIEW ENQUIRY: ' + cast(@claimid as varchar) + ' - ' + @subject
set @senderemail=case when @senderemail='' then 'no-reply@bevalued.co.uk' else @senderemail end


select @sendername=u.FName + ' ' + u.SName
from UserData u
where u.[Hash]=@hash

select @hubemail=d.Email
from ppd3.dbo.OfficeDetails d
where id=ppd3.dbo.GetOfficeDetailsID(@claimid)

select @environment=ppd3.dbo.ServerType()

select @hubemail=case @environment when 'live' then @hubemail else 'dev-system@bevalued.co.uk' end

exec ppd3.dbo.SendMail @Recipient=@hubemail,@SenderEmail=@senderemail,@SenderName=@sendername,@Subject=@emailsubject,@r2=@cc,@Body=@body,@isHTML=0
GO
