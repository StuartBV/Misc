SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[claimproducts_vw] as
select 'PPD3' [system], claimID,catid,make,model,[description],age,value,Instruction,limit,specificvalue,createdby,createdate,alteredby,altereddate,deleted
from ppd3.dbo.ICE_ClaimProducts
union all
select 'FNOL' [system], claimID,null catid,null make,MakeModel model,[Description],null Age,ItemValue value,
null Instruction,null limit,null specificvalue,c.createdby,c.createddate createdate,c.alteredby,c.altereddate,null deleted
from fnol.dbo.FNOL_ClaimItems c

GO
