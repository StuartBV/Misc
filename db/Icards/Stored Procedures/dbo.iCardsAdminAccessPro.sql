SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsAdminAccessPro]
@userID UserID,
@adminID int,
@status char(1)
as
set nocount on
if @status='t'
begin
	insert into iCardsAdminAccess (UserID,AdminID)
	values (@userID,@adminID)
end
else
begin
	delete from iCardsAdminAccess
	where UserID=@userID and AdminID=@AdminID
end

update l set l.icards=isnull(x.access,0)
from ppd3.dbo.logon l 
left join (
	select distinct 1 [access],userid
	from  iCardsAdminAccess
	where userid=@userid
)x on x.userid=l.userid
where l.userid=@userid and isnull(x.access,0)!=l.icards
GO
