SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_ClientDetails]
	@userid varchar(30),
	@hash varchar(36), 
	@cid int
AS
SET nocount on
set transaction isolation level read uncommitted

 --ensure user allowed to view clients.
if exists (select * from [UserData] u (nolock) where [UserName] = @userid and  [Hash] = @hash AND clientid=1 and isAdmin =2) 
begin

	SELECT CID, Name, Contact, [Image], [Text],Channel, 
	Code, isnull(Parent,0) Parent,convert(char(10),createdate,103), createdby, 
	convert(char(10),alteredDate,103),alteredby,isnull(c.supplierid,0) supplierid, isnull(superfmt,'') superfmt,
	insurancecoid inscoid
	FROM Clients c
	WHERE CID=@cid
end

ELSE
	raiserror('User not authorised to view clients ',1,1)
	
set transaction isolation level read committed
GO
