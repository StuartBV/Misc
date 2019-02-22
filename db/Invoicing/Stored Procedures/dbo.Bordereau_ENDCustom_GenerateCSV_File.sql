SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Bordereau_ENDCustom_GenerateCSV_File]
@path varchar(100),
@NextBordereauNo int,
@channel varchar(20),
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
	-- Commented out due to atom: 35625
	--if exists (select * from Ordering_Bordereau where Channel=@channel and AccountRef=isnull(@accountRef,AccountRef))

	create table ##Bordereau_WithHeader([EIS prefix]  varchar(50),[EIS Policy Number]  varchar(50),[EIS Claim Number] varchar(50),ValidationNo varchar(50),InvoiceNo varchar(50),OrderDate char(10),SurnameOfPolicyHolder varchar(50),
		DeliveryPostcode varchar(50),Supplier varchar(50),ItemInvoicePrice varchar(50),AdditionalCost varchar(50),
		TotalInvoicePrice varchar(50),BordereauSentDate char(50),SageSentDate char(50),Channel varchar(50), SettlementType varchar(50))
				
	insert into ##Bordereau_WithHeader ([EIS prefix],[EIS Policy Number],[EIS Claim Number], ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyHolder, DeliveryPostcode, 
		Supplier, ItemInvoicePrice, AdditionalCost, TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType)
	select [EIS prefix],[EIS Policy Number],[EIS Claim Number], ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyholder, DeliveryPostcode, Supplier, ItemInvoicePrice, AdditionalCost, 
			TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType
	from ( 
		select 
			'EIS prefix' [EIS prefix],
			'EIS Policy Number'[EIS Policy Number], 
			'EIS Claim Number' [EIS Claim Number],			
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
			0 sKey 
	 union all 
		 select 
			PPD3.dbo.EndsleighClaimNoSplit(ob.InsCoReference,1) as [EIS prefix],
			PPD3.dbo.EndsleighClaimNoSplit(ob.InsCoReference,2) as [EIS Policy Number],
			PPD3.dbo.EndsleighClaimNoSplit(ob.InsCoReference,3) as [EIS Claim Number],
			cast(ValidationNo as varchar(10)) ValidationNo, 
			cast (InvoiceNo as varchar(6)) InvoiceNo, 
			convert(char(10),OrderDate,103) OrderDate, 
			CustomerSurname SurnameOfPolicyHolder, 
			DeliveryPostcode, 
			SupplierName Supplier, 
			cast(ItemsValue as varchar(10)) ItemInvoicePrice, 
			cast(AdditionalCost as varchar(10)) AdditionalCost, 
			cast(Total as varchar(10)) TotalInvoicePrice, 
			convert(char(10),BordereauSentDate,103) BordereauSentDate, 
			convert(char(10),SageSentDate,103) SageSentDate, 
			ob.Channel, 
			case ioc.FulfilmentType
				when 1 then 'Voucher'
				when 2 then 'Product'
				when 3 then 'Cash'
				when 5 then 'Options'
				else '' end as SettlementType,
				1 sKey
		from ORDERING_Bordereau ob 
		left join Invoicing_Order_Charges ioc on ioc.InvoiceId=ob.InvoiceNo
		where SageSentDate between @fd and @td and Channel=@channel and AccountRef=isnull(@accountRef,AccountRef)
		) x
		order by x.sKey, x.[EIS Claim Number]
																		
	set @bcp='bcp "select [EIS prefix],[EIS Policy Number],[EIS Claim Number],ValidationNo,InvoiceNo,OrderDate,SurnameOfPolicyHolder,DeliveryPostcode,Supplier,ItemInvoicePrice,AdditionalCost,TotalInvoicePrice,BordereauSentDate,SageSentDate,Channel, SettlementType from ##Bordereau_WithHeader" queryout "' + @path + 'ProductBordereauV2_' + cast(@NextBordereauNo as varchar) + '_' + @channel + '_' + isnull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + cast(serverproperty('servername') as varchar) +  ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output

	--Added 06/06/2017 LI - Atom: 66242 [to create a backup copy in \\\sqllive\h$\FilesExportedCopy]
	if dbo.ServerType()='LIVE' 
	begin
	set @bcp='bcp "select [EIS prefix],[EIS Policy Number],[EIS Claim Number],ValidationNo,InvoiceNo,OrderDate,SurnameOfPolicyHolder,DeliveryPostcode,Supplier,ItemInvoicePrice,AdditionalCost,TotalInvoicePrice,BordereauSentDate,SageSentDate,Channel, SettlementType from ##Bordereau_WithHeader" queryout "' + dbo.ExportCopyPath() + '\ProductBordereauV2_' + cast(@NextBordereauNo as varchar) + '_' + @channel + '_' + isnull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + cast(serverproperty('servername') as varchar) +  ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output
	end
    
	set @errors=@@error
			
	drop table ##Bordereau_WithHeader
end
return @errors



GO
