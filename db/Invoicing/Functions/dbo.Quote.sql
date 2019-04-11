SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[Quote](@String varchar(100))
returns varchar(1000)
as 
begin
 return '"' + @String + '"'
end
GO
