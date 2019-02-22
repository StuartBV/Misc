SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Bordereau_AXACustom_GenerateCSV_File]
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

	create table ##Bordereau_WithHeader(InsCoReference varchar(50),ValidationNo varchar(50),InvoiceNo varchar(50),OrderDate char(10),SurnameOfPolicyHolder varchar(50),
		DeliveryPostcode varchar(50),Supplier varchar(50),ItemInvoicePrice varchar(50),AdditionalCost varchar(50),
		TotalInvoicePrice varchar(50),BordereauSentDate char(50),SageSentDate char(50),Channel varchar(50), SettlementType varchar(50))
				
	insert into ##Bordereau_WithHeader (InsCoReference, ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyHolder, DeliveryPostcode, 
		Supplier, ItemInvoicePrice, AdditionalCost, TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType)
	select InsCoReference, ValidationNo, InvoiceNo, OrderDate, SurnameOfPolicyholder, DeliveryPostcode, Supplier, ItemInvoicePrice, AdditionalCost, 
			TotalInvoicePrice, BordereauSentDate, SageSentDate, Channel, SettlementType
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
			0 sKey 
	 union all 
		 select 
			InsCoReference, 
			cast(ValidationNo as varchar(10)) ValidationNo, 
			cast (InvoiceNo as varchar(6)) InvoiceNo, 
			convert(char(10),OrderDate,103) OrderDate, 
			CustomerSurname SurnameOfPolicyHolder, 
			isnull(nullif(ob.DeliveryPostcode,''),'BN22 8LD') DeliveryPostCode, 
			ob.SupplierName Supplier, 
			cast(ItemsValue as varchar(10)) ItemInvoicePrice, 
			cast(AdditionalCost as varchar(10)) AdditionalCost, 
			cast(Total as varchar(10)) TotalInvoicePrice, 
			convert(char(10),BordereauSentDate,103) BordereauSentDate, 
			convert(char(10),SageSentDate,103) SageSentDate, 
			ob.Channel, 
			case od.ProductFulfilmentType
				when 1 then 'Voucher'
				when 2 then 'Product'
				when 3 then 'Cash'
				when 5 then 'Options'
				when 8 then 'Cash'
				else '' end as SettlementType,
				1 sKey
		from ORDERING_Bordereau ob
		left join Invoicing_Order_Charges ioc on ioc.InvoiceId=ob.InvoiceNo
		left join Ordering.dbo.Ordering_Delivery od on od.DeliveryID=ob.DeliveryId
		where SageSentDate between @fd and @td and ob.Channel='AXA' and AccountRef=isnull(@accountRef,AccountRef)
	union all
		select 
			c.InsuranceClaimNo as InsuranceCoReference,
			'C' + cast(c.ClaimID as varchar(10)) as ValidationNo, 
			cast (isnull(c.InvoiceNumber,0) as varchar(8)) as InvoiceNo,
			convert(char(10),c.CreateDate,103) OrderDate, 
			cu.Lname as SurnameOfPolicyHolder, 
			cu.Postcode as DeliveryPostCode,
			'Bevalued' as Supplier, 
			cast(isnull(oi.InvoicePrice,0) as varchar(10)) ItemInvoicePrice,
			cast(isnull(oi.DFDeliveryPrice,0) as varchar(10)) AdditionalCost, 
			(select cast(sum(isnull(oi.InvoicePrice,0)) as varchar(10)) from PPD3.dbo.OrderItems oi where oi.ClaimID = c.ClaimID and oi.Type = 'q' and oi.Status!='X' group by ClaimID) as TotalInvoicePrice, 
			'' as BordereauSentDate, 
			convert(char(10),c.InvoiceSentUTC,103) SageSentDate, 
			c.Channel,
			'Inspection' as SettlementType,
			2 sKey
		from PPD3.dbo.Claims c
		join PPD3.dbo.Customers cu on cu.ID = c.CustID
		left join PPD3.dbo.OrderItems oi on oi.ClaimID = c.ClaimID and oi.Type = 'q' and oi.Status!='X' 
		where c.AccountRef=isnull(@accountRef,c.AccountRef)
		and c.InvoiceSentUTC between @fd and @td
		and c.Channel = 'AXA'
		and isnull(c.CancelCode,0)!=99
		and c.InvoiceSentUTC is not null
		and isnull(oi.InvoicePrice,0) > 0
	) x
	order by x.sKey, x.InsCoReference
	
	--select InsCoReference,ValidationNo,InvoiceNo,OrderDate,SurnameOfPolicyHolder,DeliveryPostcode,Supplier,ItemInvoicePrice,AdditionalCost,TotalInvoicePrice,BordereauSentDate,SageSentDate,Channel, SettlementType from ##Bordereau_WithHeader
																			
	set @bcp='bcp "select InsCoReference,ValidationNo,InvoiceNo,OrderDate,SurnameOfPolicyHolder,DeliveryPostcode,Supplier,ItemInvoicePrice,AdditionalCost,TotalInvoicePrice,BordereauSentDate,SageSentDate,Channel, SettlementType from ##Bordereau_WithHeader" queryout "' + @path + 'ProductBordereauV2_' + cast(@NextBordereauNo as varchar) + '_' + @channel + '_' + isnull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + cast(serverproperty('servername') as varchar) +  ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output
	
	--Added 06/06/2017 LI - Atom: 66242 [to create a backup copy in \\sqllive\h$\FilesExportedCopy]
	if dbo.ServerType()='LIVE'
	begin
	set @bcp='bcp "select InsCoReference,ValidationNo,InvoiceNo,OrderDate,SurnameOfPolicyHolder,DeliveryPostcode,Supplier,ItemInvoicePrice,AdditionalCost,TotalInvoicePrice,BordereauSentDate,SageSentDate,Channel, SettlementType from ##Bordereau_WithHeader" queryout "' + dbo.ExportCopyPath() + '\ProductBordereauV2_' + cast(@NextBordereauNo as varchar) + '_' + @channel + '_' + isnull(@accountRef + '_', '') + @date +'.csv" -c -t, -S' + cast(serverproperty('servername') as varchar) +  ' -T'
	exec master.dbo.xp_cmdshell @bcp, no_output
	end
	
	set @errors=@@error
			
	drop table ##Bordereau_WithHeader
end
return @errors


GO
