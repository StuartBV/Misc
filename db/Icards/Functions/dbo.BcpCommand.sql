SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[BcpCommand] ()
RETURNS varchar(30)
AS  
begin
 return (
	select
	case dbo.ServerName()
		when 'QUARK2' then 'c:\WINNT\SQLBinn\bcp.exe  '
		else 'bcp '
	end
)
end
GO
