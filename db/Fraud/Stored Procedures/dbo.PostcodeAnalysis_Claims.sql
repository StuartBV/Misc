SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PostcodeAnalysis_Claims]
@from varchar(10),
@to varchar(10),
@postcode varchar(7)
as
--UTC--
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select c.claimid, c.ClaimReceivedDateUTC ClaimReceivedDate, c.IncidentDateUTC IncidentDate, cu.Fname+' '+cu.Lname [name], cu.Address1 [address], cu.Postcode, c.CauseofClaim,
s5.[description] causeofclaimdetail,
ppd3.dbo.ClaimCategoryConCat(c.claimid) Ccommodity,
i.Name [InsuranceCo], c.AllowedRRP [claimvalue], s1.[description] [cmsstatus],
case when f.ClaimID is not null then 'Yes' else 'No' end [TSCase],
case when f.ClaimID is not null then s2.[description] else '' end [TSStatus],
case when f.ClaimID is not null then s3.[description] else '' end [TSRisk],
case when f.ClaimID is not null then s4.[description] else '' end [TSReasonClosed]
from ppd3.dbo.claims c join ppd3.dbo.ClaimProperties cp  on c.ClaimID = cp.ClaimID
join ppd3.dbo.Customers cu  on c.CustID=cu.id
join ppd3.dbo.InsuranceCos i  on c.InsuranceCoID=i.ID
join ppd3.dbo.sysLookup s1 on s1.tablename='ClaimStatus' and s1.code=c.[status]
left join fraud.dbo.claims fc  on c.claimid=fc.OriginClaimID
left join fraud.dbo.fraud f  on fc.ClaimID = f.ClaimID and f.OriginatingSys='ppd3'
left join sysLookup s2 on s2.tablename='FraudStatus' and s2.code=f.[status]
left join sysLookup s3 on s3.tablename='Risk' and s3.code=f.risk
left join sysLookup s4 on s4.tablename='CloseReason' and s4.code=f.ReasonClosed
left join ppd3.dbo.sysLookup s5 on s5.tablename='causeofclaimdetail' and s5.code=cp.CauseOfClaimDetail
where c.ClaimReceivedDateUTC between @fd and @td
and c.CancelCode!=99 
and left(cu.Postcode,7)=@postcode
GO
