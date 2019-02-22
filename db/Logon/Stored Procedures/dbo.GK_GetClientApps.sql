SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_GetClientApps] 
	@userid varchar(30),
	@hash varchar(36), 
	@cid int
AS SET nocount on

set transaction isolation level read uncommitted

 --ensure user allowed to view clients.
if exists (select * from [UserData] u  where [UserName] = @userid and  [Hash] = @hash AND clientid=1 and isAdmin >=2) 
BEGIN
	SELECT a.aid,a.name,
	case WHEN ca.aid IS null THEN '' ELSE 'checked' END AS Selected
	from Apps a 
	LEFT JOIN ClientApps ca  ON ca.AID = a.AID and ca.CID=@cid
	ORDER BY 1
end

ELSE
	raiserror('User not authorised to list client Apps ',1,1)
	
set transaction isolation level read committed
GO
