SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ClaimCommodityConCat] (@claimid int)  
returns varchar(500)
as  
begin
	declare @cat varchar(500)=''

	select @cat=@cat + isnull(GroupType,'') + case when GroupType is null then '' else ', ' end
	from (
		select distinct GroupType
		from FNOL_ClaimItems
		where claimid=@claimid
	)x

	if @cat!=''
	 set @cat=left(@cat,len(@cat)-1)

	return @cat
end
GO
