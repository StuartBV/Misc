SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ReserveSum]
(
	-- Add the parameters for the function here
	@claimid int
)
returns money
as
begin
	-- Declare the return variable here
	declare @sum money

	select @sum=CASE 
	when DateFinalised is not null then 0
	when total_cost>estimate then 0 
	else estimate-total_cost 
	END
	FROM fnol_claims WHERE claimid=@claimid
	
	-- Return the result of the function
	RETURN @sum

end

GO
