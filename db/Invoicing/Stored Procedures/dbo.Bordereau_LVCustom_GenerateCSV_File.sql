SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Bordereau_LVCustom_GenerateCSV_File]
@path varchar(100),
@NextBordereauNo int,
@from varchar(20), 
@to varchar(20),
@accountRef varchar(50) = null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @date varchar(20), @errors int, @bcp varchar(4000), @fd datetime,@td datetime,@sql varchar(4000)

select @fd=cast(@from as datetime), @td=dateadd(mi,-1,dateadd(d,1,@to)),
		@date= replace(replace( (convert(char(8),getdate(),3) + '-' + convert(char(8),getdate(),114)),':',''),'/',''),
		@errors=0, @path=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'ProductBordereau\V2\' else @path end

if @path=''
begin
	set @errors=-1
end
else
begin
	create table ##LVbordereau (BVRef varchar(50),LVRef varchar(50),BVInvoiceNumber varchar(50),CustomerSurname varchar(50),
		ClaimExposure varchar(50),PaymentType varchar(50),AmountIncVAT varchar(50), PerOrderDeliveryFee varchar(50),VatAmount varchar(50),
		Excess varchar(50),Discount varchar(50),Betterment varchar(50),RepairReplace varchar(50),DateOfService varchar(50),ServiceProvided varchar(50),DA varchar(50),
		DateInvoicePaid varchar(50),RevisedInvoice varchar(50),Supplier varchar(50),SettlementType varchar(50))

	insert into ##LVbordereau (BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount, Excess,
	Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType)
	select BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount,  Excess,
	Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType
	from ( 
		select 
			'BV - Ref' BVRef,
			'LV - Ref' LVRef,
			'BV Invoice Number' BVInvoiceNumber, 
			'Customer Surname' CustomerSurname,
			'Claim Exposure' ClaimExposure, 
			'Payment Type' PaymentType,
			'Amount inc VAT' AmountIncVAT, 
			'Per Order Delivery Fee' PerOrderDeliveryFee,
			'Vat Amount' VatAmount,
			'Excess' Excess,
			'Discount' Discount,
			'Betterment' Betterment,
			'Repair/Replace' RepairReplace,
			'Date of Service' DateOfService,
			'Service Provided' ServiceProvided,
			'DA-Y/N' DA,
			'Date Invoice Paid (for LV=use)' DateInvoicePaid,
			'Revised Invoice' RevisedInvoice,
			'Supplier' Supplier,
			'Settlement Type' SettlementType
		union all 
		select 
			convert(varchar,odi.ItemReference) [BV - Ref], 
			convert(varchar,od.Reference) [LV -Ref],
			convert(varchar,ii.InvoiceNo) [BV Invoice Number],
			coalesce(cu.Surname,cu.EmailAddress,'Not Supplied') [Customer Surname],
			'' [Claim Exposure],
			'Final' [Payment Type],
			cast(isnull(sum(iii.PriceGross)+ii.DeliveryCostGross+ii.InstallCostGross+ii.DisposalCostGross,0) as varchar(50)) [AmountIncVAT],	-- Adding Del,Ins,Dis will give incorrect figures if the invoice has more than one item. LS wants this initial to see the values
			case when row_number() over (partition by odi.DeliveryId ORDER BY odi.ItemId)=1 then cast(ii.OrderChargesNet as varchar(50)) else '0' end [Per Order Delivery Fee],
			cast(isnull(sum(iii.PriceGross-iii.PriceNet)+( (ii.DeliveryCostGross+ii.InstallCostGross+ii.DisposalCostGross) - (ii.DeliveryCostNet+ii.InstallCostNet+ii.DisposalCostNet ) ),0) as varchar(50)) [VatAmount],	-- Adding Del,Ins,Dis will give incorrect figures if the invoice has more than one item. LS wants this initial to see the values
			cast(sum(odi.ExcessDeducted) as varchar(50)) [Excess],
			'' [Discount],
			'' [Betterment],
			'Replace' [Repair/Replace],
			'' [Date of Service],
			odi.Category [Service Provided],
			'N' [DA-Y/N],
			'' [Date Invoice Paid (for LV Use)],
			case when exists( select * from Invoicing_Invoices di where di.SourceKey=ii.SourceKey and di.SourceType=ii.SourceType and di.InvoiceNo!=ii.InvoiceNo ) then 'Y' else 'N' end [Revised Invoice],
			d.[Name] [Supplier],
			cft.[Description] [Settlement Type]
		from Invoicing_Invoices ii
		join INVOICING_Items iii on ii.InvoiceNo=iii.InvoiceId
		join PPD3.dbo.Distributor d on d.ID = ii.SupplierId
		join Ordering.dbo.Ordering_DeliveryItems odi on iii.DeliveryItemId = odi.ItemId
		join Ordering.dbo.Ordering_Delivery od on odi.DeliveryId = od.Id
		join Ordering.dbo.Ordering_Customer cu on cu.Id = od.CustomerId
		join Ordering.dbo.Ordering_ProductFulfilmentTypes cft on od.ProductFulfilmentType = cft.Id
		where SageSentDate between @fd and @td and 
		AccountRef=isnull(@accountRef,AccountRef) and od.InscoId = 1150	and 
		ii.BordereauSentDate is null
		group by odi.ItemReference, od.Reference, ii.InvoiceNo, cu.Surname, od.InscoId, cft.[Description], d.[Name], odi.Category, od.Id, cu.EmailAddress,
		ii.DeliveryCostGross, ii.InstallCostGross, ii.DisposalCostGross, ii.DeliveryCostNet, ii.InstallCostNet, ii.DisposalCostNet, ii.SourceType, ii.SourceKey, ii.OrderChargesNet, odi.DeliveryId, odi.ItemId
	) x

	set @bcp='bcp "select BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount, Excess, Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType from ##LVbordereau" queryout "' + @path + 'ProductBordereauV2_' + cast(@NextBordereauNo as varchar) + '_LV_' + isnull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + cast(serverproperty('servername') as varchar) + ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output

	--Added 06/06/2017 LI - Atom: 66242 [to create a backup copy in \\sqllive\h$\FilesExportedCopy]
	if dbo.ServerType()='LIVE' 
	begin
		set @bcp='bcp "select BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount, Excess, Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType from ##LVbordereau" queryout "' + dbo.ExportCopyPath() + '\ProductBordereauV2_' + cast(@NextBordereauNo as varchar) + '_LV_' + isnull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + cast(serverproperty('servername') as varchar) + ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output
	end

	set @errors=@@error
			
	drop table ##LVbordereau
end
return @errors


GO
