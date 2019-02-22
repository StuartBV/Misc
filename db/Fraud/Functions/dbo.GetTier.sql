SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[GetTier](@claimid int)  
returns tinyint
as
begin

	/*
	Rules for deciding Tier:
	a) If claim has no SF Indicator then go to Tier 2
	b) If claim has any SF Indicator then go to Tier 1
	- other than when
	c) If claim has an SF Indicator and is for Jewellery and is also a multi-commodity claim the go to Tier 2
	d) If claim has SF Indicators 55 or 69 then go to Tier 2
	*/
	declare @isMultiCommodity tinyint, @isSF tinyint,@tier tinyint,@Ind smallint

	select @isMultiCommodity=0, @isSF=0

	/* check if claim is for jewellery and is also a multi-commodity claim*/
	if exists (
		select x.claimid from (
			select cc2.claimid,count(*) as freq
			from ppd3.dbo.claimcategories cc2
			where cc2.claimID=@claimid
			group by cc2.claimid
			having count(*) > 1
		)x join ppd3.dbo.claimcategories cc on cc.claimID = x.claimid and cc.SuperFmt='j'
	)
	begin 
		set @isMultiCommodity=1
	end

	/* check if claim has SF indicator */
	select @Ind=FraudIndicator from ppd3.dbo.ClaimProperties where claimid=@claimid
	if @Ind!=0 and @Ind!=99999
	begin 
		set @isSF=1
	end

	/* decide what Tier the claim should go to*/
	if @isSF=0
		begin
			set @tier=2	
		end
	else if @isMultiCommodity=1
		begin
			set @tier=2	
		end
	else
		begin 
			if @Ind=55 or @Ind=69
				begin 
					set @tier=2
				end
			else
				begin
					set @tier=1
				end
		end 

	return @tier

end







GO
