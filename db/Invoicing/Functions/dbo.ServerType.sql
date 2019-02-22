SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ServerType] ()
returns varchar(50)
as  
begin
 return (ppd3.dbo.servertype())
end
GO
