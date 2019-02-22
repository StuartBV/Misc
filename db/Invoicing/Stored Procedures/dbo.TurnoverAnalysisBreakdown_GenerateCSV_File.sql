SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[TurnoverAnalysisBreakdown_GenerateCSV_File]
@outputpath varchar(100),
@channel varchar(50),
@From varchar(10),
@to varchar(10),
@accountRef varchar(50)=null,
@InsuranceCompany int = null --Invoice Bordereau screen expects this parameter.
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @fd datetime, @td datetime, @date varchar(20), @errors int=0, @bcp varchar(500), @sn varchar(50)=dbo.ServerName()
select @fd=cast(@From as datetime), @td=dateadd(mi,-1,dateadd(d,1,@to))

select @outputpath=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'ProductBordereau\V2\' else @outputpath end, 
	@date= replace(replace( (convert(char(8),getdate(),3) + '-' + convert(char(8),getdate(),114)),':',''),'/','')

if @outputpath =''
begin
	set @errors=-1
end
else
begin

	create table #tmp_t(OrderId int,Reference varchar(30),Supplier varchar(60))
		
	insert into #tmp_t (OrderId, Reference, Supplier )
	select o.Id, o.Reference, sn.name	
	from Invoicing_Orders o 
	left join SupplierName sn on sn.[id]=o.SupplierId
	left join PPD3.dbo.ValidationSuppliers vs on vs.[Type]=o.Channel and vs.SupplierID=o.SupplierId
	left join PPD3.dbo.InsuranceCos c on o.InscoID = c.ID
	where o.SageSentDate between @fd and @td 
	and vs.SupplierID is null
	and o.Channel=isnull(@channel, o.channel) 
	and (c.V2SageAccountRef is null or c.V2SageAccountRef=isnull(@accountRef,c.V2SageAccountRef))
	and o.SourceType not in (2,4,6)

	truncate table Worktable_TurnoverAnalysisBreakdown

	insert into Worktable_TurnoverAnalysisBreakdown (Reference,Category, Qty, NetPrice, GrossPrice, Vat, SupplierName,SettlementType)
		select 
		x.Reference, 
		x.Category, 
		cast(sum(x.qty) as varchar) as qty, 
		cast(convert(decimal(8,2),sum(x.PriceNet)) as varchar) as PriceNet, 
		cast(convert(decimal(8,2),sum(x.PriceGross)) as varchar) as PriceGross, 
		cast(convert(decimal(8,2),sum(x.PriceGross) - sum(x.PriceNet)) as varchar) as Vat,
		x.supplier,
		x.SettlementType 
	from (
		select y.Reference,
			   y.Category,
			   sum(y.Qty) as Qty,
			   sum(y.PriceNet) as PriceNet,
			   sum(y.PriceGross) as PriceGross,
			   y.Supplier,
			   y.SettlementType
		from (
			select 
				t.Reference, 
				I.Category,
				count(*) Qty,
				sum(isnull(I.PriceNet,0)) PriceNet,
				sum(isnull(I.PriceGross,0)) PriceGross,
				t.supplier,
				isnull((select top 1 
					case isnull(oc.FulfilmentType,0)
						when 1 then 'Voucher'
						when 2 then 'Product'
						when 3 then 'Cash'
						when 5 then 'Options'
						else '' 
					end 
				from Invoicing_Order_Charges oc 
				where oc.InvoiceId=I.InvoiceId),'') as SettlementType
			from #tmp_t t
			join INVOICING_Items I on I.OrderId=t.OrderId
			group by I.Category, t.supplier, t.Reference, i.PriceNet, i.PriceGross, i.InvoiceId
			having (sum(isnull(I.PriceNet,0)) > 0) or (sum(isnull(I.PriceGross,0)) > 0)
		) y
		group by y.Category, y.supplier, y.Reference, y.SettlementType
	union all
		select
			t.Reference, 
			I.Category,
			0 as Qty,
			(sum(isnull(ic.PriceNet,0)) + sum(isnull(oc.PriceNet,0))) as PriceNet,
			(sum(isnull(ic.PriceGross,0)) + sum(isnull(oc.PriceGross,0))) as PriceGross,
			t.supplier,
			case isnull(oc.FulfilmentType,0)
				when 1 then 'Voucher'
				when 2 then 'Product'
				when 3 then 'Cash'
				when 5 then 'Options'
				else '' 
			end SettlementType
		from #tmp_t t
		join INVOICING_Items I on I.OrderId=t.OrderId
		left join Invoicing_ItemCharges ic on ic.ItemId=I.ItemId
		left join Invoicing_Order_Charges oc on oc.InvoiceId=I.InvoiceId
		group by t.Reference,i.Category, t.supplier, isnull(oc.FulfilmentType,0)
		having (sum(isnull(ic.PriceNet,0)) > 0) or (sum(isnull(ic.PriceGross,0)) > 0) or (sum(isnull(oc.PriceNet,0)) > 0) or (sum(isnull(oc.PriceGross,0)) > 0)
	) x
	group by x.Category, x.supplier, x.Reference, x.SettlementType
	
	drop table #tmp_t

	--Original Code:

	--select o.Reference, I.Category,cast(count(*) as varchar) Qty,
	--cast(I.PriceNet						+ sum(isnull(ic.PriceNet,0))						+ sum(isnull(oc.PriceNet,0) ) as varchar) NetPrice,
	--cast(I.PriceGross					+ sum(isnull(ic.PriceGross,0))					+ sum(isnull(oc.PriceGross,0) ) as varchar) GrossPrice,
	--cast(I.PriceGross-I.PriceNet	+ sum(isnull(ic.PriceGross-ic.PriceNet,0))	+ sum(isnull(oc.PriceGross-oc.PriceNet,0) ) as varchar) Vat,
	--sn.name,
	--case when 
	--	oc.FulfilmentType = 1 then 'Voucher' else 
	--	case when oc.FulfilmentType = 2 then 'Product' else 
	--	case when oc.FulfilmentType = 3 then 'Cash' else 
	--	case when oc.FulfilmentType = 5 then 'Options' else 
	--	'' end end end end SettlementType
	-- from Invoicing_Orders o 
	--join INVOICING_Items I on I.OrderId=o.Id
	--left join Invoicing_ItemCharges ic on ic.ItemId=I.ItemId
	--left join Invoicing_Order_Charges oc on oc.InvoiceId=I.InvoiceId
	--left join SupplierName sn on sn.[id]=o.SupplierId
	--left join PPD3.dbo.ValidationSuppliers vs on vs.[Type]=o.Channel and vs.SupplierID=o.SupplierId
	--left join PPD3.dbo.InsuranceCos c on o.InscoID = c.ID
	--where vs.SupplierID is null 
	--	and o.SageSentDate between @fd and @td 
	--	and o.Channel=@channel 
	--	and (c.V2SageAccountRef is null or c.V2SageAccountRef=isnull(@accountRef,c.V2SageAccountRef))
	--	and o.SourceType in (1,3,5)
	--group by I.Category,sn.name, o.Reference,oc.FulfilmentType, i.PriceNet, i.PriceGross
	
	if exists (select * from Worktable_TurnoverAnalysisBreakdown)
	begin
		set @bcp= PPD3.dbo.BcpCommand() + 'invoicing.dbo.TurnoverAnalysisBreakdown_Headings out "' + @outputpath + 'V2TurnoverAnalysisBreakdown_' + @date +'.csv" -c -t, -S' + @sn + ' -T'
		exec master.dbo.xp_cmdshell @bcp,no_output
		set @errors=@@error
		
		if dbo.ServerType()='LIVE' -- Output copy of file for reference
		begin
			set @bcp= PPD3.dbo.BcpCommand() + 'invoicing.dbo.TurnoverAnalysisBreakdown_Headings out "' + dbo.ExportCopyPath() + '\V2TurnoverAnalysisBreakdown_' + @date +'.csv" -c -t, -S' + @sn + ' -T'
		exec master.dbo.xp_cmdshell @bcp,no_output
		end
	end
end
return @errors


GO
