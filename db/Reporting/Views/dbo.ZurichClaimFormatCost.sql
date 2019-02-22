SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[ZurichClaimFormatCost]
as
select c.claimid, p.format, sum(oi.invoiceprice) Cost
from SN_PPD3_Claims c
join SN_PPD3_OrderItems oi on oi.claimid=c.claimid and oi.[type]='Q'
join SN_PPD3_Products p on p.prodid=oi.prodid
where c.invoicenumber>0 and c.createdate> '20101001' and c.claimreceiveddateUTC >'20101001' and c.insurancecoid in (99,1039,1060)
group by c.claimid, p.format
GO
