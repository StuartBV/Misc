SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[TurnoverAnalysis_Headings] as
select top 1000000 Category, Qty, NetPrice, GrossPrice, Vat, SupplierName,SettlementType from (
	select Category, Qty, NetPrice, GrossPrice, Vat,suppliername,SettlementType,1 skey
	from Worktable_TurnoverAnalysis
	union all
	select 'Category' Category, 'Qty' Qty, 'NetPrice' NetPrice, 'GrossPrice' GrossPrice, 'Vat' Vat, 'SupplierName' SupplierName, 'SettlementType' SettlementType ,0 skey
)x
order by skey ,x.Category
GO
