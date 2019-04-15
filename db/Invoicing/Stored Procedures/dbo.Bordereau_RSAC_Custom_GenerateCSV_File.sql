SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Bordereau_RSAC_Custom_GenerateCSV_File]
@Path varchar(100), 
@NextBordereauNo int, 
@Channel varchar(20), 
@From varchar(20), 
@To varchar(20), 
@AccountRef varchar(50) = null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @Date varchar(20), @Errors int, @bcp varchar(4000), @fd datetime, @td datetime

create table ##Bordereau_WithHeader(InsCoReference varchar(50), ValidationNo varchar(50), InvoiceNo varchar(50), OrderDate char(10), SurnameOfPolicyHolder varchar(50), 
	DeliveryPostcode varchar(50), Supplier varchar(50), ItemInvoicePrice varchar(50), AdditionalCost varchar(50), 
	TotalInvoicePrice varchar(50), BordereauSentDate char(50), SageSentDate char(50), Channel varchar(50), SettlementType varchar(50), VATDeduction varchar(50), AmountToPay varchar(50))

select @fd=Cast(@From as datetime), @td=DateAdd(mi, -1, DateAdd(d, 1, @To)), 
		@Date=Replace(Replace( (Convert(char(8), GetDate(), 3) + '-' + Convert(char(8), GetDate(), 114)), ':', ''), '/', ''), 
		@Errors=0, @Path=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'ProductBordereau\V2\' else @Path end

if @Path=''
begin
	set @Errors=-1
end
else
begin
	insert into ##Bordereau_WithHeader (InsCoReference, ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyHolder, DeliveryPostcode, 
		Supplier, ItemInvoicePrice, AdditionalCost, TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType, VATDeduction, AmountToPay)
	select InsCoReference, ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyholder, DeliveryPostcode, Supplier, ItemInvoicePrice, AdditionalCost, 
			TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType, VATDeduction, AmountToPay
	from ( 
		select 
			'Insurance Company Reference' InsCoReference, 
			'Validation Number' ValidationNo, 
			'Invoice Number' InvoiceNo, 
			'Order Date' OrderDate, 
			'Surname of PolicyHolder' SurnameOfPolicyholder, 
			'Delivery Postcode' DeliveryPostcode, 
			'Supplier' Supplier, 
			'Item Invoice Price' ItemInvoicePrice, 
			'Additional Cost' AdditionalCost, 
			'Total Invoice Price' TotalInvoicePrice, 
			'Bordereau Sent Date' BordereauSentDate, 
			'Sage Sent Date' SageSentDate, 
			'Channel' Channel, 
			'SettlementType' SettlementType, 
			'VAT Deduction' VATDeduction, 
			'Amount To Pay' AmountToPay, 
			0 sKey 
	 union all 
		 select 
			InsCoReference, 
			Cast(ValidationNo as varchar(10)) ValidationNo, 
			Cast (InvoiceNo as varchar(6)) InvoiceNo, 
			Convert(char(10), OrderDate, 103) OrderDate, 
			CustomerSurname SurnameOfPolicyHolder, 
			IsNull(NullIf(ob.DeliveryPostcode, ''), 'BN22 8LD') DeliveryPostCode, 
			ob.SupplierName Supplier, 
			Cast(ItemsValue as varchar(10)) ItemInvoicePrice, 
			Cast(AdditionalCost as varchar(10)) AdditionalCost, 
			Cast(Total as varchar(10)) TotalInvoicePrice, 
			Convert(char(10), BordereauSentDate, 103) BordereauSentDate, 
			Convert(char(10), SageSentDate, 103) SageSentDate, 
			ob.Channel, 
			case od.ProductFulfilmentType
				when 1 then 'Voucher'
				when 2 then 'Product'
				when 3 then 'Cash'
				when 5 then 'Options'
				when 7 then 'Cash'
				when 8 then 'Cash'
				else '' end as SettlementType, 
			Cast(ob.VATDeducted as varchar(10)) VATDeducted, 
			Cast(Total - ob.VATDeducted as varchar(10)) AmountToPay, 
			1 sKey
		from ORDERING_Bordereau ob
		left join Invoicing_Order_Charges ioc on ioc.InvoiceId=ob.InvoiceNo
		left join Ordering.dbo.Ordering_Delivery od on od.DeliveryID=ob.DeliveryID
		where ob.SageSentDate between @fd and @td and ob.Channel=@Channel and ob.AccountRef=IsNull(@AccountRef, ob.AccountRef)
		) x
		order by x.sKey, x.InsCoReference

	set @bcp='bcp "select InsCoReference, ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyHolder, DeliveryPostcode, Supplier, ItemInvoicePrice, AdditionalCost, TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType, VATDeducted, AmountToPay from ##Bordereau_WithHeader" queryout "' + @Path + 'ProductBordereauV2_' + Cast(@NextBordereauNo as varchar) + '_' + @Channel + '_' + IsNull(@AccountRef + '_', '') + @Date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output

	--Added 06/06/2017 LI - Atom: 66242 [to create a backup copy in \\sqllive\h$\FilesExportedCopy]
	if dbo.ServerType()='LIVE'
	begin
	set @bcp='bcp "select InsCoReference, ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyHolder, DeliveryPostcode, Supplier, ItemInvoicePrice, AdditionalCost, TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType, VATDeducted, AmountToPay from ##Bordereau_WithHeader" queryout "' + dbo.ExportCopyPath() + '\ProductBordereauV2_' + Cast(@NextBordereauNo as varchar) + '_' + @Channel + '_' + IsNull(@AccountRef + '_', '') + @Date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output
	end

	set @Errors=@@Error

end

drop table ##Bordereau_WithHeader

return @Errors

GO
