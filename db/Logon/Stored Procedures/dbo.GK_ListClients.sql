SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_ListClients]
	@hash varchar (50),
	@cid varchar(10)=''
AS
set nocount on
set transaction isolation level read uncommitted
if exists (select * from userdata u  where [hash] = @hash)
begin
	if @cid = '' 
	begin
		select CID,[Name],[Code],isnull(c.supplierid,0) supplierid from [Clients] c  order by supplierid,[name]
	end
	else
	begin
		select CID,[Name],[Code],isnull(c.supplierid,0) supplierid from [Clients] c  where cid = @cid order by [name]
	end
end
set transaction isolation level read committed
GO
