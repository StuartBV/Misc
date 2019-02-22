SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[EstimateMessageData_Get_Estimate]
@queueID int
as
set nocount on

-- Standing Data
select case ds.eventType when 0 then 'Y' else 'N' end DataToSend,
	ds.messageType, ds.MessageID TransactionID,
	left(ltrim(rtrim(case ds.InsurancePolicyNo when '' then 'Unknown' else InsurancePolicyNo end)),20) as PolicyNumber,
	convert(varchar(10),coalesce(ds.IncidentDate,ds.ClaimReceivedDate,getdate()),103) IncidentDate,
	'NU13 035' RoleTypeCode,
	isnull(tc.CPLTitleCode,'B53 003') TitleCode,
	isnull(tc.CPLTitleDescription,'Mr') TitleCodeDescription,
	case when isnull(ds.fname,'')='' then 'Unknown' else left(ds.Fname,15) end FirstForename,
	case when isnull(ds.Lname,'')='' then 'Unknown' else left(ds.Lname,30) end Surname,
	case when isnull(ds.Address1,'')='' then 'Unknown' else left(ds.Address1,45) end AddressLine1,
	isnull(nullif(ds.Postcode,''),'Unknown') Postcode,
	dbo.FormatReference(ds.CPLEstimateID) as SupplierReference,
	'NU10 001' OperationCode,
	isnull(m.eCode,'unknown') eSupplierCode,
	isnull(m.SupplierNameForXml,'unknown') eSupplierName,
	'NU26 IP' SupplierRoleType,
	isnull(ds.Excess,0) Excess,
	--case when Delegated=1 then 'True' else 'False' end as DelegatedAuthorityInd,
	-- Kevin Baker agreed DelegatedAuthorityInd to be set to 'true' in all cases 09/11/2010, MH.
	-- Otherwise sub-supplier appointment estimates are put on hold by default
	'True' as DelegatedAuthorityInd,
	case when ml.DateSent is null then 'N' else case when ds.SupplierID=10000100 then 'N' else 'Y' end end as SendCancellation,
	ival.eCode as SupplierCompanyID,
	ival.SupplierNameForXml as SupplierCompanyName,
	left(ds.InsuranceClaimNo,20) as ClaimNumber
from MessageQueue.dbo.[Queue] q 
join Data_Standing ds on ds.MessageID=q.[id] and ds.MessageType='E'
join messageLog ml on ml.sourcekey=ds.sourcekey and ml.supplierID=ds.supplierID and ml.MessageType='E'
join eCodeMappings_Ranked(@queueID,null) m on m.messageid=ds.messageid
join eCodeMappings_Ranked(@queueID,10000101) ival on ival.messageid=ds.messageid
left join TitleCodeMappings tc on tc.CMSTitle=ds.Title
where q.[id]=@queueID

-- Item detail
select 'OR' ListOwner, '1' ListNo,	--di.MessageID ListNo,
	isnull(di.ItemTypeCode,'1050213C') ItemTypeCode,
	--left(di.CatNum,20) SupplierItemReference,
	cast(row_number() over (order by di.sourcekey) as varchar(20)) SupplierItemReference,	-- Take your duplicate item reference malarky and shove it
	left(di.[description],50) ItemDetailDescription,
	di.sourcekey,
	sum(di.netprice) NetPrice,
	di.vatrate,di.catnum,
	'NU10 001' OperationCode, 
	count(*) as NoOf,
	avg(di.NetPrice) UnitPrice,
	case when di.VatRate=1 then 'False' else 'True' end VatApplicableInd,
	avg(di.VatAmount) VatAmount,
	cast((di.vatrate-1)*100 as decimal(8,2)) as VatPercent,
	convert(char(10),cast(avg(cast(cast(convert(char(8),di.ItemCreateDate,112) as datetime) as int)) as datetime),120) as RateEffectiveDate,
	isnull(m.eCode,'unknown') eSupplierCode
from MessageQueue.dbo.[Queue] q
join Data_Standing ds on ds.MessageID=q.[id] and ds.MessageType='E'
join Data_Item di on di.MessageID=ds.MessageID and di.NetPrice>0
left join ppd3.dbo.supplierconfig sc on sc.supplierID=ds.supplierID and sc.channel=ds.channel
join eCodeMappings_Ranked(@queueID,null) m on m.messageid=ds.messageid
where q.[id]=@queueID and isnull(sc.HoldingItemsOnly,0)=0
group by di.sourcekey,di.VatRate,di.catnum,di.[Description],m.eCode, di.ItemTypeCode
order by 7

GO
