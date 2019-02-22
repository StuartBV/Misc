SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Ordering_Bordereau_Headings] as

select top 10000
	InsCoReference,
	ValidationNo,
	InvoiceNo,
	OrderDate,
	CustomerSurname SurnameOfPolicyholder,
	DeliveryPostcode, 
	SupplierName Supplier, 
	ItemsValue ItemInvoicePrice, 
	AdditionalCost,
	Total TotalInvoicePrice, 
	channel, 
	skey,
	BordereauSentDate,
	SageSentDate  
from (
	select 
		InsCoReference,
		cast(ValidationNo as varchar(10)) ValidationNo,
		cast (InvoiceNo as varchar(6)) InvoiceNo,
		convert(char(10),OrderDate,103) OrderDate,
		CustomerSurname,
		DeliveryPostcode,
		SupplierName,
		cast(ItemsValue as varchar(10)) ItemsValue,
		cast(DeliveryCost + InstallationCost + DisposalCost + OrderCharges as varchar(10)) AdditionalCost,
		cast(Total as varchar(10)) Total,
		1 skey,
		Channel,
		convert(char(10),BordereauSentDate,103) BordereauSentDate,
		convert(char(10),SageSentDate,103) SageSentDate  
		from ORDERING_Bordereau
	union all
		select 
			'Insurance Company Reference' InsCoReference,
			'Validation Number' ValidationNo,
			'Invoice Number' InvoiceNo,
			'Order Date' OrderDate,
			'Surname of PolicyHolder' SurnameOfPolicyholder,
			'Delivery Postcode' DeliveryPostcode, 
			'Supplier' SupplierName,
			'Item Invoice Price' ItemInvoicePrice, 
			'Additional Cost' AdditionalCost, 
			'Total Invoice Price' TotalInvoicePrice, 
			0 skey, 
			'Channel' Channel,
			'Bordereau Sent Date' BordereauSentDate,
			'Sage Sent Date' SageSentDate  
		)x
order by skey,x.InsCoReference
GO
