SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[NewFraud]
@claimID int,
@UserID UserID,
@tier int=null,
@manual tinyint=0
as
--UTC--
set nocount on

set transaction isolation level read uncommitted

declare @fin varchar(10),@num varchar(6),@prefix varchar(5),@amount_claimed money,@initial_reserve money,@excess money,@ID int,@sf int

set @UserID = replace(@UserID,'%2E','.')
if (select count(*) from claims where originclaimid=@claimID )=0
begin

--get next FIN number from syslookup
	select @num=code,@prefix=ExtraCode from sysLookup where TableName='FraudNumber'

begin tran
	update sysLookup set Code=cast(cast(code as int)+1 as varchar) where TableName='FraudNumber'
	set @fin=@prefix+@num

	--copy relevant data from customers table
	insert into Customers (Title,Fname,Lname,BusinessName,VATregistered,Address1,Address2,Address3,Town,County,Postcode,Country,
	Hphone,Wphone,Mphone,Fax,email,otherinfo,CreateDate,CreatedBy,AlteredDate,AlteredBy,SecondName,SecondPhone)
	select Title,Fname,Lname,BusinessName,VATregistered,Address1,Address2,Address3,Town,County,Postcode,Country,
	Hphone,Wphone,Mphone,Fax,email,otherinfo,cu.CreateDate,cu.CreatedBy,cu.AlteredDate,cu.AlteredBy,SecondName,SecondPhone
	from ppd3.dbo.Customers cu 
	join ppd3.dbo.claims cl on cl.CustID=cu.ID and cl.claimid=@claimID

	set @ID=scope_identity()

	--copy relevant data from claims table
	insert into claims
	(ClaimNo,OriginClaimID,QuoteCreatedDate,QuoteCreatedBy,OrderCreatedDate,OrderCreatedBy,OrderConfirmedDate,OrderConfirmedBy,QuoteSentDate,QuoteSentMethod
	,QuoteFaxNum,CustID,AccountRef,InsuranceCoID,LossADjusterID,AllowedQty,AllowedRRP,AllowedDisc,delegated,excess,Channel,BrokerAdjuster
	,LAOffice,OriginatingOffice,Inspector,InspectorRef,InspectorEmail,InsurancePolicyNo,InsuranceClaimNo,LossAdjusterRef,causeofClaim,DateListReceived
	,FirstContactDate,ContactByPhone,AllowInitialLetter,AllowedBy,ContactLetterSent,[Status],CompletedDate,ExcessToCollect,ExcessPaid,UpgradeValue
	,UpgradePaid,Pending,QuoteNote,RRPVoucher,CancelCode,CreateDate,CreatedBy,AlteredDate,AlteredBy,ClaimType,CrimeRefNumber,IncidentDate
	,ClaimReceivedDate,CauseofClaimNotes,SePScode,CancelDate,InspectorPhone,SALimit,HRLimit,OtherLimit,OfficeID,Commercial,ListExclude) 
	select 
	ClaimID,ClaimID,QuoteCreatedDateUTC,QuoteCreatedBy,OrderCreatedDateUTC,OrderCreatedBy,OrderConfirmedDateUTC,OrderConfirmedBy,QuoteSentDateUTC,QuoteSentMethod
	,QuoteFaxNum,@ID,AccountRef,InsuranceCoID,LossADjusterID,AllowedQty,AllowedRRP,AllowedDisc,delegated,excess,Channel,BrokerAdjuster
	,LAOffice,OriginatingOffice,Inspector,InspectorRef,InspectorEmail,InsurancePolicyNo,InsuranceClaimNo,LossAdjusterRef,causeofClaim,DateListReceivedUTC
	,FirstContactDateUTC,ContactByPhone,AllowInitialLetter,AllowedBy,ContactLetterSentUTC,[Status],CompletedDateUTC,ExcessToCollect,ExcessPaidUTC,UpgradeValue
	,UpgradePaidUTC,Pending,QuoteNote,RRPVoucher,CancelCode,CreateDate,CreatedBy,AlteredDate,AlteredBy,ClaimType,CrimeRefNumber,IncidentDateUTC
	,ClaimReceivedDateUTC,CauseofClaimNotes,SePScode,CancelDateUTC,InspectorPhone,SALimit,HRLimit,OtherLimit,OfficeID,Commercial,ListExclude
	from ppd3.dbo.claims
	where claimid=@claimID

	set @ID=scope_identity()

	--copy relevant data from claimproperties table
	if exists (select * from ClaimProperties cp where cp.ClaimID=@ID)
			begin
				update cpn set 
					ClaimID=@ID,
					AllowCashSettle=cpo.AllowCashSettle,
					CashSettlePerc=cpo.CashSettlePerc,
					AlteredDate=getdate(),
					AlteredBy=@UserID,
					Fraud=cpo.Fraud,
					ReferAuthBy=cpo.ReferAuthBy,
					PolicyInceptionDate=cpo.PolicyInceptionDate,
					CallScript=cpo.CallScript,
					PreviousClaim=cpo.PreviousClaim,
					PreviousRepair=cpo.PreviousRepair,
					CauseOfClaimDetail=cpo.CauseOfClaimDetail,
					NoPolicyNumberConfirmed=cpo.NoPolicyNumberConfirmed,
					FraudIndicator=cpo.FraudIndicator
				from ClaimProperties cpo
				join ClaimProperties cpn on cpn.ClaimID=@ID
				where cpo.ClaimID=@claimID
			end
		else
			begin
				insert into ClaimProperties (ClaimID,AllowCashSettle,CashSettlePerc,CreateDate,CreatedBy,Fraud,ReferAuthBy,PolicyInceptionDate,
					CallScript,PreviousClaim,PreviousRepair,CauseOfClaimDetail,NoPolicyNumberConfirmed,FraudIndicator) 
				select @ID,AllowCashSettle,CashSettlePerc,CreateDate,CreatedBy,Fraud,ReferAuthBy,PolicyInceptionDate,
				CallScript,PreviousClaim,PreviousRepair,CauseOfClaimDetail,NoPolicyNumberConfirmed,FraudIndicator
				from ppd3.dbo.ClaimProperties where claimid=@claimID
			end
	select @sf=isnull(fraudindicator,0),@tier=2 -- added by DF for CRF100194 
	from ppd3.dbo.claimproperties
	where claimid=@claimID

	--create new fraud record
	insert into Fraud (FIN,ClaimID,CurrentTier,[status],originatingsys,createdate,createdby,[Manual])
	values (@fin,@ID,@tier,1,'PPD3',getdate(),@UserID,@manual ) 

	--copy relevant data about the products on the claim
	insert into ClaimProducts (claimid,catid,make,model,[description],age,value,Instruction,limit,specificvalue,createdby,createdate,alteredby,altereddate,deleted) 
	select @ID,catid,make,model,[description],age,value,Instruction,limit,specificvalue,createdby,createdate,alteredby,altereddate,deleted
	from ppd3.dbo.ICE_ClaimProducts
	where claimid=@claimID

	--update finance details in claimproperties table
	select @amount_claimed=isnull(sum(ci.value),0),
	@initial_reserve=isnull(sum(ci.value),0)-c.excess,
	@excess=c.excess
	from Claims c 
	left join ClaimProducts ci on c.ClaimID = ci.ClaimID
	where c.ClaimID=@ID
	group by c.ClaimID,c.excess

	update claimproperties set amount_claimed=@amount_claimed,initial_reserve=@initial_reserve,excess=@excess where claimid=@ID

	--create log entry
	exec LogEvent @FIN = @fin, @UserID = @UserID, @Tier = @tier, @Status = 1, @Action = 1

	-- Create Fraud Screening Fee (where applicable)
	-- CRF100104 by MH 19/08/2009	
	exec dbo.Invoice_FraudFee_Insert @claimid=@claimid

commit tran
end


GO
