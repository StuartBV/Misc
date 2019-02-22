SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_PasswordChange] 
	@userID varchar(20),
	@currentpassword varchar(20),
	@newpw varchar(20)
as
set nocount on
set transaction isolation level read uncommitted

if exists (select * from UserData where userName=@userID and @currentpassword =[password])
begin
	if exists (select * from PWExclude where [password] like '%' +@newpw + '%')
	begin
		select Result=2 -- password not 'secure'
		return
	end
	
	begin tran
		update UserData set [password]=@newpw,changedPW=getdate()
		where userName=@userID
		select Result=0 -- else password changed.
	commit
end
else
begin
	select Result=1-- password is not correct.
end
set transaction isolation level read committed
GO
