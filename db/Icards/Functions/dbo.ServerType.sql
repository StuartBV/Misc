SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ServerType] ()
RETURNS varchar(50)
AS  
begin
 return (
	select case servertype 
		when 0 then 'Live'
		when 2 then 'Test'
		when 3 then 'Training'
		when 4 then 'Demo'
		when 10 then 'Live'
		else	'Dev'
	end ServerType		
	from ppd3.dbo.servers where servername=serverproperty('servername')
)
end
GO
