SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rep_ArgosOptionsWeeklyVolume] as

declare @fd datetime=getdate()-7, @td datetime=getdate()

select OptionsRef, CustomerName, CustomerPostCode, Product, Category, CatID, DateOrdered, TotalArgosCardValue, Excess, TotalRRP from (
	select 0 as col, 'OptionsRef' OptionsRef,'CustomerName' CustomerName,'CustomerPostCode' CustomerPostCode,
		'Product' product, 'Category' category, 'CatID' catid, 'DateOrdered' DateOrdered, 'TotalArgosCardValue' TotalArgosCardValue,
		'Excess' Excess, 'TotalRRP' TotalRRP
	union all
	select 1 as col, cc.ClaimNoPrefix + cast(p.ICardsID as varchar) OptionsRef, 
		isnull(cu.title + ' ' + cu.firstname + ' ' +cu.lastname,'') CustomerName, 
		case when isnull(cu2.postcode,'')!=isnull(cu.postcode,'') and cu2.postcode is not null then
			isnull(cu2.postcode,'')
		else
			isnull(cu.postcode,'') end CustomerPostCode, 
		pr.make + ' ' + pr.title Product,
		sys.[description] Commodity,
		pr.catnum CatID,
		cast(convert(char(10),t.CreateDate,103)+' '+convert(char(5),t.CreateDate,14) as varchar) DateOrdered,
		cast(ts.RRP - case when cl.ExcessPayMethod='External_Options' then cl.excess else 0 end as varchar) TotalArgosCardValue,
		case when cl.ExcessPayMethod='External_Options' then cast(cl.excess as varchar) else '' end Excess,
		cast(ts.RRP as varchar) TotalRRP
	from policies p join card_companies cc on cc.ID=p.CompanyID
	join customers cu on cu.ID=p.customerid
	join cards c on c.customerid=cu.ID
	join transactions t on t.cardid=c.ID
	join transactionsuppliers ts on ts.transactionID=t.ID and supplierID=6261
	left join ppd3.dbo.claims cl on cl.claimid=p.ivalref
	left join ppd3.dbo.customers cu2 on cu2.id=cl.custid
	left join ppd3.dbo.orderitems oi on oi.claimid=cl.claimid and oi.[type]='o' and [action] between 108 and 111
	left join ppd3.dbo.products pr on pr.prodid=oi.prodid
	left join ppd3.dbo.format f on f.format=pr.format
	left join ppd3.dbo.syslookup sys on sys.code=f.superfmt and sys.tablename='Superfmt'
	where t.CreateDate between @fd and @td and pr.distributor=6261
	union all
	select 2 as col, '','','','','','','TOTAL', cast(sum(ts.RRP - case when cl.[ExcessPayMethod]='External_Options' then cl.excess else 0 end) as varchar),'',''
	from policies p join card_companies cc on cc.ID=p.CompanyID
	join customers cu on cu.ID=p.customerid
	join cards c on c.customerid=cu.ID
	join transactions t on t.cardid=c.ID
	join transactionsuppliers ts on ts.transactionID=t.ID and supplierID=6261
	left join ppd3.dbo.claims cl on cl.claimid=p.ivalref
	left join ppd3.dbo.orderitems oi on oi.claimid=cl.claimid and oi.[type]='o' and [action] between 108 and 111
	left join ppd3.dbo.products pr on pr.prodid=oi.prodid
	where t.CreateDate between @fd and @td
	and pr.distributor=6261
)x
order by col
GO
