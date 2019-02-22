SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PushExternalInvoiceToCpl]
@supplierid int
as
set nocount on

-- Holy sheeeeet
-- I'm commenting this out for now until you add missing primary keys / indexes

/*
create table #ToInvoice (did int)
declare @Did int, @MessageId int, @dt datetime=getdate()

insert into #ToInvoice (did)
select distinct DID
from ExternalCpl.dbo.CplInvoiceData
where CplInvoiceSent is null and MatchStatus='Y' and SupplierId=@supplierid 

begin tran
	while exists (select * from #ToInvoice) 
	begin
		select top 1 @Did=did from #ToInvoice

		insert into MessageQueue.dbo.[Queue] (EventID,EventType, SourceSystem, SourceKey, EventTypeConfigID, CreateDate)
		values (0, 800, 'ExternalCpl', @Did, 47, @dt)

		set @MessageId=scope_identity() 

		-- insert item data
		insert into Data_Item (MessageID, SourceSystem, EventID, SupplierID, SourceKey, ItemID, ProdID, NetPrice, VatRate, CatNum, [Description],
														ItemTypeCode, ProductHash, ItemCreateDate, CreateDate, CreatedBy, VatAmount)
		select @MessageId, 'ExternalCPL', 0, @supplierid, @Did, 0, 0, cid.NetCost, cid.ChargableVatRate, cid.Catnum, cid.[Description],
			tc.CPLCode, '', @dt, @dt,'sys.etl', cid.GrossCost - cid.NetCost
		from ExternalCpl.dbo.CplInvoiceData cid
		join Ordering_CPL_ItemTypeCodes tc on tc.Category=cid.Category
		where cid.DID=@Did

		-- Insert standing Data (invoice)
		insert into SupplierEventsCollation.dbo.Data_Standing (MessageID, SourceSystem, EventID, EventType, MessageType, SupplierID, SourceKey, Channel, Excess, OriginatingOffice, InsuranceClaimNo, InsurancePolicyNo, 
																														InvoiceNumber, InvoiceSent, InvoiceTotal, IncidentDate, ClaimReceivedDate, Delegated, Title, Fname, Lname, Address1, Postcode, 
																														Hphone, Wphone, Mphone, CreateDate, CreatedBy, Data)
		select distinct @MessageId, 'ExternalCpl',  0, 800, 'I',  cid.SupplierId,  cid.DID,  'Ival',  oc.Excess,  '',  oc.InsuranceClaimNo,  oc.InsurancePolicyNo, 
			cid.InvoiceNumber, @dt, x.invoiceAmount, oc.IncidentDate, @dt, odc.Title, odc.Forename, odc.Surname, oa.Address1, oa.Postcode, odc.EveningPhone, 
			odc.DaytimePhone, odc.MobilePhone, @dt,'sys.etl',0,0
		from ExternalCpl.dbo.CplInvoiceData cid
		join (
			select DID, sum(NetCost) as invoiceAmount
			from ExternalCpl.dbo.CplInvoiceData
			group by DID
		) x on x.DID=cid.DID
		join Ordering.dbo.Ordering_Delivery od on od.Id=cid.DID
		join Ordering.dbo.Ordering_Customer odc on odc.Id=od.CustomerId
		join Ordering.dbo.Ordering_Address oa on oa.DeliveryId=cid.DID
		join Ordering.dbo.Ordering_Claims oc on oc.DeliveryId=od.DeliveryID
		where cid.DID=@Did

		--update invoice row
		update ExternalCpl.dbo.CplInvoiceData set
			CplInvoiceSent=@dt,
			AlteredBy='sys'
		where DID=@Did

		delete from #ToInvoice
		where did=@Did

	end 
commit

drop table #ToInvoice

*/
GO
