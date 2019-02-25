SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rep_IntegrityCheck] 
@headers tinyint=0
as
set transaction isolation level read uncommitted

select OptionsRef, [type], CustomerName, CustomerAddress, CustomerPostCode, DeliveryCustomerAddress, DeliveryCustomerPostCode,SchemeName, PolicyNumber, ClaimNumber, ContactName, ContactNumber, IncidentDate, CardType, TransactionType, CardValue, RequestDate, BatchFileUploaded, UploadStatus,
	AuthorisationRequired, Cancelled
from (
	select 'A' as seq, 'iVal Options Card Weekly Integrity Check Report' as OptionsRef, '' as [type], '' as CustomerName,'' as CustomerAddress, '' as CustomerPostCode, '' as DeliveryCustomerAddress, '' as DeliveryCustomerPostCode, '' as SchemeName,
	'' as PolicyNumber, '' as ClaimNumber, '' as ContactName, '' as ContactNumber, '' as IncidentDate, '' as CardType, '' as TransactionType,  '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	union all 
	select 'B' as seq, '' as OptionsRef, '' as [type], '' as CustomerName,'' as CustomerAddress, '' as CustomerPostCode, '' as DeliveryCustomerAddress, '' as DeliveryCustomerPostCode, '' as SchemeName,
	'' as PolicyNumber, '' as ClaimNumber, '' as ContactName, '' as ContactNumber, '' as IncidentDate, '' as CardType, '' as TransactionType, '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	union all 
	select 'C' as seq, 'Options Ref' as OptionsRef, 'Type' as [type], 'Surname' as CustomerName, 'Customer Address' as CustomerAddress, 'Postcode' as CustomerPostCode, 'Customer Delivery Address' as DeliveryCustomerAddress, 'Delivery Postcode' as DeliveryCustomerPostCode,'Scheme' as SchemeName,
	'Policy Number' as PolicyNumber, 'Claim Number' as ClaimNumber, 'Contact Name' as ContactName, 'Contact Number' as ContactNumber, 'Incident Date' as IncidentDate, 'Card [type]' as CardType, 'Transaction [type]' as TransactionType, 'Card Value' as CardValue, 'Request Date' as RequestDate,
	'Batch File Uploaded' as BatchFileUploaded, 'Upload Status' as UploadStatus, 'Authorisation Required' as AuthorisationRequired, 'Cancelled?' as Cancelled, '' as createdate where @headers=1
	union all 
	select 'D' as seq,
		cc.ClaimNoPrefix + cast(p.ICardsID as varchar) OptionsRef, 
		case when t.CreatedBy='sys' then 'Goldsmiths Team' else 
			case when p.CreatedBy!='sys' and ivalref is not null then 'iVal Team' else 'Options Team' end
		end [type], 
		isnull(cu.title + ' ' + cu.firstname + ' ' +cu.lastname,'') CustomerName, 
		case when isnull(cu.Address1+', '+cu.Address2+', '+cu.Town+', '+cu.County,'')!=isnull(cu2.Address1+', '+cu2.Address2+', '+cu2.Town+', '+cu2.County,'') and cu2.address1 is not null then
			isnull(cu2.Address1+', '+cu2.Address2+', '+cu2.Town+', '+cu2.County,'')
		else
			isnull(cu.Address1+', '+cu.Address2+', '+cu.Town+', '+cu.County,'') end CustomerAddress,
		case when isnull(cu2.postcode,'')!=isnull(cu.postcode,'') and cu2.postcode is not null then
			isnull(cu2.postcode,'')
		else
			isnull(cu.postcode,'') end CustomerPostCode, 
		isnull(cu.Address1+', '+cu.Address2+', '+cu.Town+', '+cu.County,'') DeliveryCustomerAddress,
		isnull(cu.postcode,'') DeliveryCustomerPostCode, 
		isnull(seps.accountref + ' - ' + seps.schemename,'') SchemeName,
		isnull(p.InsurancePolicyNo,'') PolicyNumber,
		isnull(p.InsuranceClaimNo,'') ClaimNumber, 
		case when t.CreatedBy='sys' then 'Kelly Sharpe (Goldsmiths)' else -- Standard Goldsmiths Contact Name
			case when t.CreatedBy!='sys' and ivalref is not null then 
				isnull(case when p.contactname='' then e.fname+' '+e.sname+' (iVal)' else p.contactname end, e.fname+' '+e.sname+' (iVal)') 
			else 
				case when p.contactname in ('','NONE') and p.cancelreason is not null then 'Cancelled'
				else isnull(p.contactname,'') end  
			end
		end ContactName,
		case when t.CreatedBy='sys' then '01162 817667' else -- Standard Goldsmiths Contact Number --WTF WTF WTF!!! This should be from a lookup, not hard coded!!
			case when t.CreatedBy!='sys' and ivalref is not null then 
				isnull(case when p.contactphone='' then '0845 602 9604' else p.contactphone end, '0845 602 9604') --WTF WTF WTF!!! This should be from a lookup, not hard coded!!
			else 
				case when p.contactphone in ('','NONE') and p.cancelreason is not null then 'Cancelled'
				else isnull(p.contactphone,'') end  
			end
		end ContactPhone,
		isnull(convert(char(10),p.IncidentDate,103),'') IncidentDate,
		isnull(sys.Description,'') CardType, 
		case when t.[type]='M' then 'New Card'
				when t.[type]='R' then 'Reissue Card'  
				when t.[type]='B' then 'Add/Subtract Value' else 'ERROR'
		end as TransactionType,
		cast(t.cardvalue as varchar) CardValue,
		convert(char(10),t.CreateDate,103)+' '+convert(char(5),t.CreateDate,14) RequestDate,
		isnull(convert(char(10),t.BatchFileUploaded,103)+' '+convert(char(5),t.BatchFileUploaded,14),'') BatchFileUploaded,
		case when t.status=2 then 'Upload Completed' else
			case when t.uploaderror is not null then 'Error with upload' else
				case when p.cancelreason is not null then 'Cancelled' else 'Awaiting Upload' end
			end
		end as UploadStatus,
		case when t.AuthRequirement>0 and t.AuthDate is null then 'Awaiting Authorisation' else 
			case when t.AuthRequirement>0 and t.AuthDate is not null then 'Authorised' else 'Not Required' end		
		end as AuthorisationRequired,
		case when p.cancelreason is not null then 'Yes - '+sys2.Description else '' end as Cancelled,
		t.createdate
	from policies p join ppd3.dbo.SepsBranches seps on p.SePSCode=seps.AccountRef
	join card_companies cc on cc.ID=p.CompanyID
	join customers cu on cu.ID=p.customerid
	join cards c on c.customerid=cu.ID
	join transactions t on t.cardid=c.ID
	left join ppd3.dbo.claims cl on cl.claimid=p.ivalref
	left join ppd3.dbo.customers cu2 on cu2.id=cl.custid
	left join syslookup sys on sys.Code = c.Cardtype and sys.TableName = 'CardType'
	left join syslookup sys2 on sys2.Code = p.CancelReason and sys2.TableName = 'CancelReason'
	left join ppd3.dbo.logon l on t.createdby=l.UserID
	left join ppd3.dbo.employees e on e.ID=l.userfk
)x
order by seq, UploadStatus, x.CreateDate desc


GO
