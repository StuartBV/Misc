SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[FinalSettlement]
(
	@id int	
)
returns money
as
begin
	-- Declare the return variable here
	declare @sum money
		
	select @sum=isnull(convert(money,([ProposedSettlement] * (1 - convert(decimal,[deduction]) / 100))-case when ci.ExcessTaken=1 then c.Excess else 0 end),0)
	FROM fnol_claimItems ci (nolock) 
	join fnol_claims c (nolock) on ci.ClaimID = c.ClaimID
	where ci.id=@id
	
	
	-- Return the result of the function
	RETURN @sum

end



GO
