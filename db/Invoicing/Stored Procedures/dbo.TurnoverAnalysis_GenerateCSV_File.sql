SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TurnoverAnalysis_GenerateCSV_File]
@outputpath varchar(100),
@channel varchar(50),
@From varchar(10),
@to varchar(10),
@accountRef varchar(50)=null,
@InsuranceCompany int=null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @fd datetime, @td datetime, @date varchar(20), @errors int=0, @bcp varchar(500),@sn varchar(50)=dbo.ServerName()
select @fd=cast(@From as datetime), @td=dateadd(mi,-1,dateadd(d,1,@to))

select @outputpath=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'ProductBordereau\V2\' else @outputpath end, 
	@date=replace(replace( (convert(char(8),getdate(),3) + '-' + convert(char(8),getdate(),114)),':',''),'/','')

if @outputpath=''
begin
	set @errors=-1
end
else
begin
	truncate table Worktable_TurnoverAnalysis
	insert into Worktable_TurnoverAnalysis (Category, Qty, NetPrice, GrossPrice, Vat, SupplierName, ClaimNumber, SettlementType)
	select I.Category,cast(count(*) as varchar) Qty,
	cast(I.PriceNet + sum(isnull(ic.PriceNet,0)) + sum(isnull(oc.PriceNet,0) ) as varchar) NetPrice,
	cast(I.PriceGross + sum(isnull(ic.PriceGross,0)) + sum(isnull(oc.PriceGross,0) ) as varchar) GrossPrice,
	cast(I.PriceGross-I.PriceNet	+ sum(isnull(ic.PriceGross-ic.PriceNet,0)) + sum(isnull(oc.PriceGross-oc.PriceNet,0) ) as varchar) Vat,
	sn.name,
	o.Reference as ClaimNumber,
		case when oc.FulfilmentType=1 then 'Voucher' else 
		case when oc.FulfilmentType=2 then 'Product' else 
		case when oc.FulfilmentType=3 then 'Cash' else 
		case when oc.FulfilmentType=5 then 'Options' else 
		'' end end end end SettlementType
	from Invoicing_Orders o 
	join INVOICING_Items I on I.OrderId=o.Id
	left join Invoicing_ItemCharges ic on ic.ItemId=I.ItemId
	left join Invoicing_Order_Charges oc on oc.InvoiceId=I.InvoiceId
	left join SupplierName sn on sn.[id]=o.SupplierId
	left join PPD3.dbo.ValidationSuppliers vs on vs.[Type]=o.Channel and vs.SupplierID=o.SupplierId
	left join PPD3.dbo.InsuranceCos c on o.InscoID=c.ID
	where vs.SupplierID is null 
		and o.SourceType not in (2,4,6) -- Validator and Claim Companion (CC added for 60515 BH 11042017)
		and o.SageSentDate between @fd and @td 
		and o.Channel=@channel
		and (c.V2SageAccountRef is null or c.V2SageAccountRef=isnull(@accountRef,c.V2SageAccountRef))
	group by I.Category,sn.name, o.Reference, oc.FulfilmentType, i.PriceNet, i.PriceGross

	if exists (select * from Worktable_TurnoverAnalysis)
	begin
		set @bcp= PPD3.dbo.BcpCommand() + 'Invoicing.dbo.TurnoverAnalysis_Headings out "' + @outputpath + 'V2TurnoverAnalysis_' + @date +'.csv" -c -t, -S' + @sn + ' -T'
		exec master.dbo.xp_cmdshell @bcp,no_output
		set @errors=@@error
		
		if dbo.ServerType()='LIVE' -- Output copy of file for reference
		begin
			set @bcp= PPD3.dbo.BcpCommand() + 'Invoicing.dbo.TurnoverAnalysis_Headings out "' + dbo.ExportCopyPath() + '\V2TurnoverAnalysis_' + @date +'.csv" -c -t, -S' + @sn + ' -T'
			exec master.dbo.xp_cmdshell @bcp,no_output
		end
	end
end
return @errors


GO
