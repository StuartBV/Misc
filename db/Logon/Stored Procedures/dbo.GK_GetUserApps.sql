SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GK_GetUserApps]
	@hash varchar(36)=''
AS
set nocount on
set transaction isolation level read uncommitted

select 
	a.name, a.URL,
	isnull(convert(char(20),LastLogin,100),'Never') as lastLogin,
	u.[FName] +' '+ u.[SName] as [name], a.OpenInParent as ParentOpen, a.[AID] as AppID
from UserData u 
join Clients c  on c.CID=u.ClientID
join ClientApps ca  on ca.CID=c.CID
join Apps a  on a.AID=ca.AID
where u.Hash=@hash AND a.aid>0 and a.[Enabled]=1

set transaction isolation level read committed
GO
