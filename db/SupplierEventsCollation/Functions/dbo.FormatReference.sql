SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[FormatReference] (@ref varchar(50))
returns varchar(25)
as
-- Removes the trailing slash, if any, from @ref

begin
	
	declare @return varchar(50)
	set @return=case right(@ref,1) when '/' then left(@ref,len(@ref)-1) else @ref end
	if len(@return)>25
	begin
		-- If longer than 25, remove PP supplierID and replace with *
		set @return=replace(@return,'/10000100/','/*/')
	end
	return @return
end

GO
