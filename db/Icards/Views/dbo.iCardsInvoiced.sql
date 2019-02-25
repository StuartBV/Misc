SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[iCardsInvoiced]
as
select
	cc.id [companyid],
	p.[ICardsID],
	min(t.[InvoicedDate]) InvoiceDate,
	sum(t.cardvalue) Value
from dbo.Card_companies cc (nolock)
left join policies p with (nolock) on cc.id=p.CompanyID
left join customers cu with (nolock) ON cu.ID=p.customerid
left join cards c with (nolock) ON c.customerid=cu.ID
left join transactions t with (nolock) ON t.cardid=c.ID
group by cc.id,p.[ICardsID]


GO
