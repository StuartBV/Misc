SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[IP_WIP_ClaimCategory]
as
select x.claimid, x.category
from (
	select cc.claimid, 'mix' as Category
	from SN_PPD3_ClaimCategories cc
	group by cc.claimid
	having count(*)>1
	union
	select y.claimid, cc.SuperFmt as Category
	from (
		select cc.claimid
		from SN_PPD3_ClaimCategories cc
		group by cc.claimid
		having count(*)=1
	)y
	join SN_PPD3_ClaimCategories cc on cc.claimid=y.claimID
)x
GO
