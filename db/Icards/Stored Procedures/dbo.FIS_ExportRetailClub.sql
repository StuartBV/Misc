SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[FIS_ExportRetailClub]
AS
select  1 as Tag,
		null as Parent,
		null as [RTCLUB!1],
		null as [MERCHANT!2!ACTION!Element],
		null as [MERCHANT!2!INSTCODE!Element],
		null as [MERCHANT!2!CLUBREF!Element],
		null as [MERCHANT!2!AIID!Element],
		null as [MERCHANT!2!MRCHID!Element],
		null as [MERCHANT!2!MRCLOC!Element],
		null as [MERCHANT!2!DESCR!Element],
		null as [MERCHANT!2!COMPANY!Element]
union all
select  2 as Tag,
		1 as Parent,
		null as [RTCLUB!1],
		'A' as [MERCHANT!2!ACTION!Element],
		'AVI' as [MERCHANT!2!INSTCODE!Element], --Changed to AVI as requested by FIS 15/06/2011
		'AVIVA RTL Club' as [MERCHANT!2!CLUBREF!Element],
		aiid as [MERCHANT!2!AIID!Element],
		mrchid as [MERCHANT!2!MRCHID!Element],
		MrchLoc as [MERCHANT!2!MRCLOC!Element],
		descr as [MERCHANT!2!DESCR!Element],
		Company as [MERCHANT!2!COMPANY!Element]
from FISRetailClub
order by tag
for xml Explicit

GO
