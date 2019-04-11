SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[DeQuote](@String varchar(100))
returns varchar(1000)
as 
begin
 return Replace(@string,'"','')
end
GO
