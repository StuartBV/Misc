SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ClaimItems_MonitoringReport]
@startdate varchar(10),
@enddate varchar(10)

as

set transaction isolation level read uncommitted
set nocount on
set dateformat dmy
declare @start datetime, @end datetime

select @start=cast(@startdate as datetime), @end=cast(@enddate + ' 23:59:59' as datetime)


select
		c.ClaimID ID,
		c.ClientRefNo [docref],
		c.Title+' '+c.Fname+' '+c.sname customer,
		c.Postcode,
		ClaimHandler agent,
		c.DateFinalised [dateclosed]
	from FNOL_claims c 
	where c.DateFinalised between @start and @end
	and exists (	
		SELECT * 
		from dbo.FNOL_ClaimItems ci
		where ci.ClaimID=c.claimid
		and ci.Outcome!=6
		and (
			isnull(ci.AssetNo,'')='' or
			isnull(ci.MakeModel,'')='' or
			isnull(ci.Description,'')='' or
			isnull(ci.ItemValue,0)=0 or
			isnull(ci.Age,0)=0 or
			isnull(ci.Category1,'')='' or
			isnull(ci.Category2,'')='' or
			isnull(ci.GroupType,'')='' or
			isnull(ci.Substantiation,0)=0 or
			isnull(ci.ValidationType,0)=0 or
			isnull(ci.ProposedSettlement,0)=0 or
			isnull(ci.Deduction,0)=0 or
			isnull(ci.Outcome,'')='' or
			isnull(ci.SettlementType,0)=0 or
			isnull(ci.FinalSettlement,0)=0 
		)
	)



GO
