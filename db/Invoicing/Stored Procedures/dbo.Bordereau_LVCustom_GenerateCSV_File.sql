SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Bordereau_LVCustom_GenerateCSV_File]
@path varchar(100), 
@NextBordereauNo int, 
@from varchar(20), 
@to varchar(20), 
@accountRef varchar(50)=null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @date varchar(20), @errors int, @bcp varchar(4000), @fd datetime, @td datetime

select @fd=Cast(@from as datetime), @td=DateAdd(mi, -1, DateAdd(d, 1, @to)), 
		@date= Replace(Replace( (Convert(char(8), GetDate(), 3) + '-' + Convert(char(8), GetDate(), 114)), ':', ''), '/', ''), 
		@errors=0, @path=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'ProductBordereau\V2\' else @path end

if @path=''
begin
	set @errors=-1
end
else
begin
	create table ##LVbordereau (BVRef varchar(10), LVRef varchar(10), BVInvoiceNumber varchar(10), CustomerSurname varchar(50), 
		ClaimExposure varchar(50), PaymentType varchar(50), AmountIncVAT varchar(50), PerOrderDeliveryFee varchar(50), VatAmount varchar(50), 
		Excess varchar(10), AmountToPay varchar(15), Discount varchar(50), Betterment varchar(50), RepairReplace varchar(50), DateOfService varchar(50), ServiceProvided varchar(50), DA varchar(50), 
		DateInvoicePaid varchar(50), RevisedInvoice varchar(50), Supplier varchar(50), SettlementType varchar(50))

	insert into ##LVbordereau (BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount, Excess, AmountToPay, 
	Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType)
	select BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount,  Excess, AmountToPay, 
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
			'Amount To Pay' AmountToPay, 
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
			Cast(IsNull(odi.ItemReference, od.SourceKey) as varchar(10)) [BV - Ref], 
			Cast(od.Reference as varchar(10)) [LV - Ref], 
			Cast(ii.InvoiceNo as varchar(10)) [BV Invoice Number], 
			Coalesce(cu.Surname, cu.EmailAddress, 'Not Supplied') [Customer Surname], 
			'' [Claim Exposure], 
			'Final' [Payment Type], 
			Cast(iii.PriceGross + IsNull(ici.DeliveryCostGross + ici.InstallCostGross + ici.DisposalCostGross, 0) as varchar(50)) AmountIncVAT, 
			case when Row_Number() over (partition by odi.DeliveryId order by odi.ItemId)=1 then Cast(ii.OrderChargesGross as varchar(50)) else '0' end [Per Order Delivery Fee], 
			Cast(iii.PriceGross-iii.PriceNet + IsNull((ici.DeliveryCostGross + ici.InstallCostGross + ici.DisposalCostGross) 
				- (ici.DeliveryCostNet + ici.InstallCostNet + ici.DisposalCostNet), 0)
				+ (case when Row_Number() over (partition by odi.DeliveryId order by odi.ItemId)=1 then ii.OrderChargesGross - ii.OrderChargesNet else 0 end) as varchar(50)) VatAmount, 
			Cast(case when Row_Number() over (partition by odi.DeliveryId order by odi.ItemId)=1 and oc.ExcessCollectedByBV=1 then oc.Excess else odi.ExcessDeducted end as varchar(10)) Excess, 
			Cast(iii.PriceGross + IsNull(ici.DeliveryCostGross + ici.InstallCostGross + ici.DisposalCostGross, 0) 
				- case when Row_Number() over (partition by odi.DeliveryId order by odi.ItemId)=1 and oc.ExcessCollectedByBV=1 then oc.Excess else 0 end 
				+ case when Row_Number() over (partition by odi.DeliveryId order by odi.ItemId)=1 then ii.OrderChargesGross else 0 end as varchar(10)) AmountToPay, 
			'' Discount, 
			'' Betterment, 
			'Replace' [Repair/Replace], 
			'' [Date of Service], 
			odi.Category [Service Provided], 
			'N' [DA-Y/N], 
			'' [Date Invoice Paid (for LV Use)], 
			case
				when exists( select * from Invoicing_Invoices di where di.SourceKey=ii.SourceKey and di.SourceType=ii.SourceType and di.InvoiceNo != ii.InvoiceNo )
			then 'Y' else 'N' end [Revised Invoice], 
			d.[Name] Supplier, 
			cft.[Description] [Settlement Type]
		from Invoicing_Invoices ii
		join INVOICING_Items iii on iii.DeliveryId=ii.DeliveryId
		left join Invoicing_ItemCharges_PerItem ici on ici.ItemId=iii.ItemId
		join PPD3.dbo.Distributor d on d.ID=ii.SupplierId
		join Ordering.dbo.Ordering_DeliveryItems odi on iii.DeliveryItemId=odi.ItemId
		join Ordering.dbo.Ordering_Delivery od on odi.DeliveryId=od.Id
		join Ordering.dbo.Ordering_Customer cu on cu.Id=od.CustomerId
		join Ordering.dbo.Ordering_ProductFulfilmentTypes cft on od.ProductFulfilmentType=cft.Id
		join Ordering.dbo.Ordering_Claims oc on oc.DeliveryId=od.Id
		where ii.SageSentDate between @fd and @td
			and AccountRef=IsNull(@accountRef, AccountRef)
			and od.InscoId=1150	
			and ii.BordereauSentDate is null
	) x

	set @bcp='bcp "select BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount, Excess, AmountToPay, Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType from ##LVbordereau" queryout "' + @path + 'ProductBordereauV2_' + Cast(@NextBordereauNo as varchar) + '_LV_' + IsNull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) + ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output

	--Added 06/06/2017 LI - Atom: 66242 [to create a backup copy in \\sqllive\h$\FilesExportedCopy]
	if dbo.ServerType()='LIVE' 
	begin
		set @bcp='bcp "select BVRef, LVRef, BVInvoiceNumber, CustomerSurname, ClaimExposure, PaymentType, AmountIncVAT, PerOrderDeliveryFee, VatAmount, Excess, AmountToPay, Discount, Betterment, RepairReplace, DateOfService, ServiceProvided, DA, DateInvoicePaid, RevisedInvoice, Supplier, SettlementType from ##LVbordereau" queryout "' + dbo.ExportCopyPath() + '\ProductBordereauV2_' + Cast(@NextBordereauNo as varchar) + '_LV_' + IsNull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) + ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output
	end

	set @errors=@@Error

	drop table ##LVbordereau
end
return @errors


GO
