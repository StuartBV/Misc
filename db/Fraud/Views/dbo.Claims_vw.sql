SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Claims_vw] as
--UTC--
select 'FNOL' [system],
c.ClientRefNo ClaimNo,c.ClaimID,null QuoteCreatedDate,null QuoteCreatedBy,null OrderCreatedDate,null OrderCreatedBy,
null OrderConfirmedDate,null OrderConfirmedBy,null QuoteSentDate,null QuoteSentMethod,
null QuoteFaxNum,null AccountRef,null InsuranceCoID,null LossADjusterID,null AllowedQty,null AllowedRRP,
null AllowedDisc,null delegated,null excess,p.Client,null BrokerAdjuster,null LAOffice,null OriginatingOffice,
null Inspector,null InspectorRef,null InspectorEmail,p.PolicyNo InsurancePolicyNo,null InsuranceClaimNo,
null LossAdjusterRef,c.Cause causeofClaim,null DateListReceived,null FirstContactDate,null ContactByPhone,
null AllowInitialLetter,null AllowedBy,null ContactLetterSent,null [Status],c.DateFinalised CompletedDate,
null ExcessToCollect,null ExcessPaid,null UpgradeValue,null UpgradePaid,null Pending,null QuoteNote,
null RRPVoucher,null CancelCode,c.CreatedDate,c.CreatedBy,c.AlteredDate,c.AlteredBy,null ClaimType,
c.CrimeRef CrimeRefNumber,c.IncidentDate,c.CreatedDate ClaimReceivedDate,c.Cause CauseofClaimNotes,
null SePScode,null CancelDate,null InspectorPhone,null SALimit,null HRLimit,null OtherLimit,
null OfficeID,null Commercial,null ListExclude, p.CustomerID custID
from fnol.dbo.FNOL_Claims c join fnol.dbo.FNOL_Policy p on c.PolicyID=p.ID 

union all 

select 'PPD3' [system],
cast(ClaimID as varchar) ClaimNo,ClaimID, QuoteCreatedDateUTC,QuoteCreatedBy,OrderCreatedDateUTC,OrderCreatedBy,OrderConfirmedDateUTC,OrderConfirmedBy,QuoteSentDateUTC,QuoteSentMethod
,QuoteFaxNum,AccountRef,InsuranceCoID,LossADjusterID,AllowedQty,AllowedRRP,AllowedDisc,delegated,excess,Channel,BrokerAdjuster
,LAOffice,OriginatingOffice,Inspector,InspectorRef,InspectorEmail,InsurancePolicyNo,InsuranceClaimNo,LossAdjusterRef,causeofClaim,DateListReceivedUTC
,FirstContactDateUTC,ContactByPhone,AllowInitialLetter,AllowedBy,ContactLetterSentUTC,[Status],CompletedDateUTC,ExcessToCollect,ExcessPaidUTC,UpgradeValue
,UpgradePaidUTC,Pending,QuoteNote,RRPVoucher,CancelCode,CreateDate,CreatedBy,AlteredDate,AlteredBy,ClaimType,CrimeRefNumber,IncidentDateUTC
,ClaimReceivedDateUTC,CauseofClaimNotes,SePScode,CancelDateUTC,InspectorPhone,SALimit,HRLimit,OtherLimit,OfficeID,Commercial,ListExclude,CustID
from ppd3.dbo.claims







GO
