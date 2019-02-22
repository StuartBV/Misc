SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[PaymentsSum]
(
	-- Add the parameters for the function here
	@claimid int,
	@type varchar(20), 
	@total tinyint
	
)
returns money
as
begin
	-- Declare the return variable here
	declare @sum money

	select @sum=isnull((
		
		select sum(case when (fcp.[type]=@type and @type in ('Payment','Recovery')) OR @type='Total' and fcp.[type]='Payment' then fcp.amount -- if we are not totalling bring back sum of items 
				else 0 end 
		)
		 
		-
		sum(case when @total=1 and fcp.[type]='Recovery' and @type='Total' then fcp.amount else 0 end)
		
		from fnol.dbo.FNOL_ClaimPayments fcp (nolock) 
		where fcp.claimid=@claimid 
			and isnull(fcp.status,'PAID')='PAID' -- New clause to only calculate totals where payments are authorised 07/11/08
		)
		
		,0)

	
	-- Return the result of the function
	RETURN @sum

end



GO
