SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ServerName]()
returns varchar(50)
as  
begin
	return ppd3.dbo.ServerName()
end
GO
