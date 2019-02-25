SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Report_TS_Cancellations_Analysis] 
@from varchar(10), 
@to varchar(10)
as
--UTC--
set nocount on
set dateformat dmy

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select c.Channel, c.claimid [CMS Ref], ic.Name InsuranceCompany, c.insuranceclaimno [Claim Number], c.insurancepolicyno [Policy Number],
cu.[Lname] [PH Name], cu.Address1, cu.Address2, cu.Town, cu.Postcode, sys.[Description] [Cancel Reason],
isnull(c.AllowedRRP,0) [Value],
convert(varchar(10),c.IncidentDateUTC,103) IncidentDate,
convert(varchar(10),c.ClaimReceivedDateUTC,103) [Date Received],
convert(varchar(10),c.CancelDateUTC,103) [Date Closed],
ccsv.Category, ppd3.dbo.ClaimCategoryConCat (c.ClaimID) [Category Detail], c.CauseofClaim Peril
from ppd3.dbo.claims c join ppd3.dbo.customers cu on cu.id=c.[CustID]
join ppd3.dbo.InsuranceCos ic on ic.id=c.InsuranceCoID
join ppd3.dbo.sysLookup sys on sys.TableName='CancelReason' and sys.Code=c.CancelCode
left join ppd3.dbo.ClaimCategoriesSingleView ccsv on ccsv.claimid=c.claimid
where c.channel in ('ival','axa','NUIBRAD','AVIVAST')
and c.CancelDateUTC between @fd and @td
--and isnull(c.AllowedRRP,0)>=case when channel='axa' then 0 else 400 end --Atom 73999 JD 04/07/2018. 
and not exists (select * from fraud.dbo.claims where OriginClaimID=c.claimid)
order by c.channel,sys.[Description],isnull(c.AllowedRRP,0)




GO
