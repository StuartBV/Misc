SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ServerName]()
returns varchar(50)
as  
begin
	return (select servername from PPD3.dbo.servers where servername=serverproperty('servername') )
end

GO
