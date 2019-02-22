SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LogEvent]
@UserID UserID,
@ID int=null,
@DocType varchar(10)
as
set nocount on
set dateformat DMY

declare @now datetime=getdate()

insert into usertracking(UserId,ID,DocType,[date])
select @UserID,@ID,@DocType,@now
where not exists (select * from dbo.UserTracking ut where ut.id=@id and ut.UserID=@userid and [date]=@now and ut.DocType=@DocType)

if @DocType='CLAIM'
begin
	exec UpdateClaimInUse @exit=0, @userid=@UserID,@claimid=@ID 
end
GO
