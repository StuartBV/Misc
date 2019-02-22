SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[EstimateMessageData_Get_Items_Added]
@queueID int,
@lastMessageID int
as
set nocount on

select 
	'OR' ListOwner,
	'1' ListNo,
	isnull(di.ItemTypeCode,'1050213C') ItemTypeCode,
	left(di.CatNum,20) SupplierItemReference,
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
from Data_Item di 
left join Data_Item dil on dil.MessageID=@lastmessageID and dil.ProductHash=di.ProductHash and dil.ItemID=di.ItemID
join Data_Standing ds on ds.MessageID=di.MessageID and ds.MessageType='E'
left join ppd3.dbo.supplierconfig sc on sc.supplierID=ds.supplierID and sc.channel=ds.channel
join eCodeMappings_Ranked(@QueueID,null) m on m.messageid=ds.messageid
where di.messageID=@QueueID and dil.MessageID is null and isnull(sc.HoldingItemsOnly,0)=0
group by di.ItemTypeCode,di.sourcekey,di.VatRate,di.catnum,di.[Description],m.eCode

GO
