SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE  FUNCTION [dbo].[AuthRequirement] 
	(@postcode VARCHAR(10),
	@CardID int,
	@value money) 
RETURNS INT
AS
BEGIN
DECLARE @auth INT
	
select @auth=case when left(@postcode,2) in ('BN','TN') OR right(cast(@CardID as varchar),1)=0 then 3 else
				case when @value between 2500 and 10000 then 1 else
					case when @value>10000 then 2 else 0 end 
				end
			end

RETURN @auth 

END

GO
