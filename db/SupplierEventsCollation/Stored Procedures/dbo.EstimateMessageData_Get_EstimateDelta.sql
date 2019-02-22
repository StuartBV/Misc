SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EstimateMessageData_Get_EstimateDelta]
@queueID int
as

set nocount on

declare @lastMessageID int, @mode tinyint	--ADD=0 -- DELETE=1		@OperationCode varchar(8)

-- Get operation code and store it as need it later for items to determine if we are sending Deletes only or Additions only
select @mode=
case when exists (
		select * from Data_Standing ds2 (nolock)
		where ds2.sourcekey=ds.sourcekey and ds2.SupplierID=ds.supplierid and ds2.MessageType=ds.messagetype
			and ds2.messageID<ds.messageID and ds2.CPLEstimateID=ds.CPLEstimateID
	) then 1 else 0 end			--then 'NU10 004' else 'NU10 001' end
from MessageQueue.dbo.[Queue] q 
join Data_Standing ds on ds.MessageID=q.[id] and ds.MessageType='E'
join messageLog ml on ml.sourcekey=ds.sourcekey and ml.supplierID=ds.supplierID and ml.MessageType='E'
where q.[id]=@QueueID

-- Standing Data
select
	case ds.eventType when 0 then 'Y' else 'N' end DataToSend,
	ds.messageType,
	ds.MessageID TransactionID,
	case ds.InsurancePolicyNo when '' then 'Unknown' else left(ds.InsurancePolicyNo,20) end PolicyNumber,
	left(ds.InsuranceClaimNo,20) ClaimNumber,
	convert(varchar(10),coalesce(ds.IncidentDate,ds.ClaimReceivedDate,getdate()),103) IncidentDate,
	'NU13 035' RoleTypeCode,
	isnull(tc.CPLTitleCode,'B53 003') TitleCode,
	isnull(tc.CPLTitleDescription,'Mr') TitleCodeDescription,
	case when isnull(ds.fname,'')='' then 'Unknown' else left(ds.Fname,15) end FirstForename,
	case when isnull(ds.Lname,'')='' then 'Unknown' else left(ds.Lname,30) end Surname,
	case when isnull(ds.Address1,'')='' then 'Unknown' else left(ds.Address1,45) end AddressLine1,
	isnull(nullif(ds.Postcode,''),'Unknown') Postcode,
	dbo.FormatReference(ds.CPLEstimateID) as SupplierReference,
	case when @mode=0 then  'NU10 001' else  'NU10 004' end  OperationCode,
	isnull(m.eCode,'unknown') eSupplierCode,
	isnull(m.SupplierNameForXml,'unknown') eSupplierName,
	'NU26 IP' SupplierRoleType,
	isnull(ds.Excess,0) Excess,
	--case when Delegated=1 then 'True' else 'False' end as DelegatedAuthorityInd,
	-- Kevin Baker agreed DelegatedAuthorityInd to be set to 'true' in all cases 09/11/2010, MH.
	-- Otherwise sub-supplier appointment estimates are put on hold by default
	'True' as DelegatedAuthorityInd,
	case when ml.DateSent is null then 'N' else case when ds.SupplierID=10000100 then 'N' else 'Y' end end as SendCancellation,
	e.eCode as SupplierCompanyID,
	e.SupplierName as SupplierCompanyName
from MessageQueue.dbo.[Queue] q 
join Data_Standing ds on ds.MessageID=q.[id] and ds.MessageType='E'
join messageLog ml on ml.sourcekey=ds.sourcekey and ml.supplierID=ds.supplierID and ml.MessageType='E'
join eCodeMappings e on e.SupplierID=10000101 and e.channel='*' 
join eCodeMappings_Ranked(@queueID,null) m on m.messageid=ds.messageid
left join TitleCodeMappings tc on tc.CMSTitle=ds.Title
where q.[id]=@queueID

-- Item detail

select @LastMessageID=
	case when exists (	-- Get ID of last message for this supplier which has been sent
		select * from MessageQueue.dbo.Queue q 
		where  q.[id]=max(ds2.MessageID) and q.DataRetrieved=1 and q.DateSent is not null
	) then max(ds2.MessageID) else 0 end 
	from Data_Standing ds
	join Data_Standing ds2 on ds2.sourcekey=ds.sourcekey
		and ds2.MessageType=ds.MessageType
		and ds2.SupplierID=ds.SupplierID
		and ds2.Data=ds.Data
		and ds2.MessageID<ds.MessageID
	where ds.MessageID=@QueueID

if @mode=0
begin
	-- Additions only
	exec EstimateMessageData_Get_Items_Added @queueID,@LastMessageID
end
else
begin
	-- Deletes only
	exec EstimateMessageData_Get_Items_Deleted @queueID,@LastMessageID
end

GO
