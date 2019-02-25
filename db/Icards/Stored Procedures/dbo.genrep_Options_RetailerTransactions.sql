SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[genrep_Options_RetailerTransactions]
@from varchar(10),
@to varchar(10)
AS
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

SELECT 
	r.Termlocation [Merchant],
	isnull(convert(char(10),r.Localdate,103),'') [DateOfTransaction],
	isnull(convert(char(5),r.Localtime,14),'') [TimeOfTransaction],
	r.Billamt [Value],
	cc.ClaimNoPrefix+cast(p.ICardsID as varchar) [FIS No],
	p.InsuranceClaimNo [Aviva Claim Ref]
FROM dbo.FIS_Reporting_TransactionExport r 
join cards c on r.pan=c.pan and r.Cardid=c.SupplierCardId
join dbo.Customers cu on c.CustomerId=cu.id
join dbo.policies p on cu.iCardsID = p.ICardsID
join dbo.Card_companies cc on cc.ID = p.CompanyID and cc.id=2
where r.transtype in ('AUTHADV','AUTHREV','ADJUST')
and r.Localdate between @fd and @td
order by r.Localdate desc
GO
