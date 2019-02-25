SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCards_InvoiceExport]
@batchno varchar(20),
@reporttype char(3)
as
--@reporttype ADD = New Values on cards
--				SUB = Values Subtracted from cards
set nocount on
set transaction isolation level read uncommitted
select [date],[Claim Number],[Policy Number],[Policy Holders Surname],[Policy Holders Post Code],[Invoice Number],[Gross Amount],[Excess Deducted Yes / no],
[Excess Amount],[Amount to be Paid],[Card create date],[Handlers RACIF ID] from (
	select 1 as Sort,
	'="'+convert(char(10),getdate(),103)+'"' [date],
	'="'+p.insuranceclaimno+'"' as [Claim Number],
	'="'+p.insurancepolicyno+'"' as [Policy Number],
	'="'+replace(p.lastname, '&','')+'"' as [Policy Holders Surname],
	'="'+upper(p.postcode)+'"' as [Policy Holders Post Code],
	'="'+cast(p.cardvalueid as varchar)+'"' as [Invoice Number],
	'="'+cast(cast(p.cardvalue+case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null and p.[type]='M' then c.excess else 0 end as decimal(8,2)) as varchar)+'"' [Gross Amount],
	case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null and p.[type]='M' then 'Yes' else 'No' end  [Excess Deducted Yes / no],
	'="'+cast(cast(case when c.excesspaymethod='External_Options' and c.excesspaidUTC is not null and p.[type]='M' then c.excess else 0 end as decimal(8,2)) as varchar)+'"'[Excess Amount],
	'="'+cast(cast(p.cardvalue as decimal(8,2)) as varchar)+'"' as [Amount to be Paid],
	'="'+p.createdate+'"'as [Card create date],
	'' as [Handlers RACIF ID],
	cast(p.ivalref as varchar)+'/10000101/OC' + cast(p.TransactionID as varchar) as CPLEstimateID
	from policydetails p 
	join ppd3.dbo.claims c  on p.ivalref=c.claimid
	join ppd3.dbo.sepsbranches s  on s.accountref=p.SepSCode
	where p.InvoicebatchNo=@batchno and p.[type]in ('B','M')
	and 1=case when @reporttype='ADD' and p.cardvalue>0 then 1 else 
		case when @reporttype='SUB' and p.cardvalue<0 then 1 else 0 end
	end
	and p.transdate>='20081103' -- date we started invoicing by excel
	and p.companyID=2
	union all
	select distinct 1 as Sort,
		'="'+convert(char(10),getdate(),103)+'"' [date],
		'="'+p.insuranceclaimno+'"' as [Claim Number],
		'="'+p.insurancepolicyno+'"' as [Policy Number],
		'="'+replace(c.lastname, '&','')+'"' as [Policy Holders Surname],
		'="'+upper(c.postcode)+'"' as [Policy Holders Post Code],
		'="'+cast(p.icardsid as varchar)+'"' as [Invoice Number],
		'="'+cast(cast(r.cardvalueoncompletion as decimal(8,2)) as varchar)+'"' [Gross Amount],
		'No' as [Excess Deducted Yes / no],
		'="0.00"'[Excess Amount],
		'="'+cast(cast(r.cardvalueoncompletion as decimal(8,2)) as varchar)+'"' as [Amount to be Paid],
		'="'+convert(varchar(10),p.createdate,103)+'"' as [Card create date],
		'' as [Handlers RACIF ID],
		cast(p.ivalref as varchar)+'/10000101/OC' + cast(r.ID as varchar) as CPLEstimateID
		from redemptions r
		join PolicyDetails p on p.iCardsIDNoPrefix=r.iCardsID and  cast(r.InvoiceBatchNo as varchar)=@batchno and @reporttype='SUB' and p.companyID=2
		join customers c on c.iCardsID=p.iCardsIDNoPrefix
	union all
	select	0 as Sort,
			'Date' as [date],
			'Claim Number' as [Claim Number],
			'Policy Number' as [Policy Number],
			'Policy Holders Surname' as [Policy Holders Surname],
			'Policy Holders Post Code' as [Policy Holders Post Code],
			'Invoice Number' as [Invoice Number],
			'Gross Amount' as [Gross Amount],
			'Excess Deducted Yes / No' as [Excess Deducted Yes / no],
			'Excess Amount' as [Excess Amount],
			'Amount to be Paid' as [Amount to be Paid],
			'Card Create Date' as [Card create date],
			'Handlers RACIF ID' as [Handlers RACIF ID],
			'CPLEstimateID' as CPLEstimateID
)x order by sort
GO
