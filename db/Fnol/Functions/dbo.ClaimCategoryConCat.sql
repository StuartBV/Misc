SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ClaimCategoryConCat] (@claimid int)  
RETURNS varchar(500)
AS  
BEGIN
	declare @cat varchar(500)

	select
		@cat=coalesce(@cat+ ',','')+category
	from (
		select distinct 
			isnull(GroupType,makemodel) category
		from FNOL_ClaimItems 
		where claimid=@claimid
		and isnull(GroupType,makemodel) is not null
	)x

	return @cat
END

GO
