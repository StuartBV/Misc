SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[TurnoverAnalysisBreakdown_Headings] as
select top 1000000 Reference, Category, Qty, NetPrice, GrossPrice, Vat, SupplierName,SettlementType from (
	select Reference, Category, Qty, NetPrice, GrossPrice, Vat, suppliername, SettlementType,1 skey
	from Worktable_TurnoverAnalysisBreakdown
	union all
	select 'Reference' Reference, 'Category' Category, 'Qty' Qty, 'NetPrice' NetPrice, 'GrossPrice' GrossPrice, 'Vat' Vat, 'SupplierName' SupplierName, 'SettlementType' SettlementType,0 skey
)x
order by skey ,x.Category, x.reference
GO
