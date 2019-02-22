SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_NewClient]
@userID UserID,
@hash varchar(50)
as
set nocount on
set transaction isolation level read uncommitted

declare @ID int
declare @clientid int
set @ID=0

 --ensure user allowed to create new clients.
if exists (select * from UserData u where UserName=@userid and [hash]=@hash and isAdmin > 0)
begin

	select @ID=cid from clients where name='New Client' -- see if we already have an ID. Ensure we never bring insert lots of clients!  
	if (@ID=0 or @id is null)
	begin
		insert into Clients (Name,Contact,[image],[text],Channel,Code,CreateDate,CreatedBy,SupplierID,Superfmt)
		select 'New Client','Enter Contact','Enter Image','Enter Welcome Text','','',getdate(),@userid,0,''
		set @ID=@@identity
	end

	select 0 as result,@ID as ID -- indicate success.
end
else
begin
	select 1 as result,@ID as ID -- not allowed to create account.
end
GO
