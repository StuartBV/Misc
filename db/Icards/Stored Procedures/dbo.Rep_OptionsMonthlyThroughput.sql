SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rep_OptionsMonthlyThroughput] 
@headers tinyint=0
as

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @qtytotal int, @valuetotal money, @start datetime=dateadd(m,-1,getdate()), @end datetime=getdate()
select @qtytotal=count(*), @valuetotal=sum(cardvalue)
from Transactions
where createdate between @start and @end

select OptionsRef, [type], Surname, PostCode, SchemeName, PolicyNumber, ClaimNumber, IncidentDate, CardType, TransactionType, CardValue, RequestDate, BatchFileUploaded, UploadStatus,
	AuthorisationRequired, Cancelled
from (
	select 'A' as seq, 'iVal Options Card Monthly Activity Report' as OptionsRef, '' as [type], '' as Surname, '' as PostCode, 
	'' as SchemeName, '' as PolicyNumber, '' as ClaimNumber, '' as IncidentDate, '' as CardType, '' as TransactionType, '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	union all 
	select 'B' as seq, '' as OptionsRef, '' as [type], '' as Surname, '' as PostCode, '' as SchemeName,
	'' as PolicyNumber, '' as ClaimNumber, '' as IncidentDate, '' as CardType, '' as TransactionType, '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	union all 
	select 'C' as seq, 'Options Ref' as OptionsRef, 'Type' as [type], 'Surname' as Surname, 'Postcode' as PostCode, 'Scheme' as SchemeName,
	'Policy Number' as PolicyNumber, 'Claim Number' as ClaimNumber, 'Incident Date' as IncidentDate, 'Card [type]' as CardType, 'Transaction [type]' as TransactionType, 'Card Value' as CardValue, 'Request Date' as RequestDate,
	'Batch File Uploaded' as BatchFileUploaded, 'Upload Status' as UploadStatus, 'Authorisation Required' as AuthorisationRequired, 'Cancelled?' as Cancelled, '' as createdate
	union all 
	select 'D' as seq,
		cc.ClaimNoPrefix + cast(p.ICardsID as varchar) OptionsRef, 
		case when p.CreatedBy='sys' then 'Goldsmiths' else 
			case when p.CreatedBy!='sys' and ivalref is not null then 'iVal' else 'Other' end
		end [type],
		isnull(cu.lastname,'') Surname, 
		isnull(cu.postcode,'') PostCode, 
		isnull(seps.accountref + ' - ' + seps.schemename,'') SchemeName,
		isnull(p.InsurancePolicyNo,'') PolicyNumber,
		isnull(p.InsuranceClaimNo,'') ClaimNumber, 
		isnull(convert(char(10),p.IncidentDate,103),'') IncidentDate,
		isnull(sl.[description],'') CardType, 
		case when t.[type]='M' then 'New Card'
				when t.[type]='R' then 'Reissue Card'  
				when t.[type]='B' then 'Add/Subtract Value' else 'ERROR'
		end as TransactionType,
		cast(t.cardvalue as varchar) CardValue,
		isnull(convert(char(10),t.CreateDate,103)+' '+convert(char(5),t.CreateDate,14),'') RequestDate,
		isnull(convert(char(10),t.BatchFileUploaded,103) +' '+convert(char(5),t.BatchFileUploaded,14),'') BatchFileUploaded,
		case when t.status=2 then 'Upload Completed' else
			case when t.uploaderror is not null then 'Error with upload' else
				case when p.cancelreason is not null then 'Cancelled' else 'Awaiting Upload' end
			end
		end as UploadStatus,
		case when t.AuthRequirement>0 and t.AuthDate is null then 'Awaiting Authorisation' else 
			case when t.AuthRequirement>0 and t.AuthDate is not null then 'Authorised' else 'Not Required' end		
		end as AuthorisationRequired,
		case when p.cancelreason is not null then 'Yes - '+sl2.[description] else '' end as Cancelled, t.createdate
	from policies p
	join ppd3.dbo.SepsBranches seps on p.SePSCode=seps.AccountRef
	left join card_companies cc on cc.ID=p.CompanyID
	left join customers cu on cu.ID=p.customerid
	left join cards c on c.customerid=cu.ID
	left join transactions t on t.cardid=c.ID
	left join syslookup sl on sl.Code = c.cardtype and sl.TableName = 'CardType'
	left join syslookup sl2 on sl2.Code = p.CancelReason and sl2.TableName = 'CancelReason'
	where t.createdate between @start and @end
	union all 
	select 'E' as seq, '' as OptionsRef, '' as [type], '' as Surname, '' as PostCode, '' as SchemeName,
	'' as PolicyNumber, '' as ClaimNumber, '' as IncidentDate, '' as CardType, 'TOTAL' as TransactionType, cast(@valuetotal as varchar)+' ' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	union all	
	select 'F' as seq, '' as OptionsRef, '' as [type], '' as Surname, '' as PostCode, '' as SchemeName,
	'' as PolicyNumber, '' as ClaimNumber, '' as IncidentDate, '' as CardType, '' as TransactionType, '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	union all
	-- Card Totals By Brand
	select seq as seq, [CardType] as OptionsRef, [Qty] as [type], [value] as Surname, '' as PostCode, '' as SchemeName, 
	'' as PolicyNumber, '' as ClaimNumber, '' as IncidentDate, '' as CardType, '' as TransactionType, '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
	from (
		select 'G' seq, 'Card [type]' [CardType], 'Qty' [Qty], 'Total Value' [value]
		union all 
		select 'H' seq, 
			sl.[description] as [CardType],
			cast(isnull(x.qty,0) as varchar) [Qty],
			cast(isnull(x.value,0) as varchar) [value]
		from syslookup sl
		left join cards c on sl.code=c.cardtype and sl.TableName='CardType'
		left join transactions t on t.cardid=c.ID
		left join (
			select 
				sl.[description] as [CardType], 
				count(*) [Qty],
				sum(t.cardvalue) [value]
			from transactions t
			left join cards c on t.cardid=c.ID
			left join syslookup sl on sl.code=c.cardtype and sl.TableName='CardType'
			where t.createdate between @start and @end
			and t.[type] in ('B','M')
			group by sl.[description]
		)x on x.cardtype=sl.[description]
		where sl.TableName='CardType'
		group by sl.[description], x.qty, x.value
	)y
	union all	
	select 'I' as seq, 'TOTAL' as OptionsRef, cast(@qtytotal as varchar) as [type], cast(@valuetotal as varchar) as Surname, '' as PostCode, '' as SchemeName,
	'' as PolicyNumber, '' as ClaimNumber, '' as IncidentDate, '' as CardType, '' as TransactionType, '' as CardValue, '' as RequestDate,
	'' as BatchFileUploaded, '' as UploadStatus, '' as AuthorisationRequired, '' as Cancelled, '' as createdate
)x
order by seq, UploadStatus, x.createdate desc

GO
