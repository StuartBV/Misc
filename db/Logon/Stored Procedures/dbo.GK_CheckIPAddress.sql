SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GK_CheckIPAddress]
	@ip varchar(15)
AS
set nocount on
set transaction isolation level read uncommitted

select distinct top 1  c.Image, c.Text, c.GKVersion
from Clients c
join IPLookup i on i.ClientID=c.CID
where i.ipaddress=@ip
order by [text] desc

GO
