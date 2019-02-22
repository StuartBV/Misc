SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[XXXCometInvoiceAggregate_Insert] as
set nocount on
truncate table CometInvoicingAggregates

return

insert into Reporting.dbo.CometInvoicingAggregates (ClaimID, Total, Commodity)
select x.ClaimID,total,dbo.SN_PPD3_Comet_ClaimCategoryConCat(x.ClaimID)
from (
	select oi.ClaimID,
	isnull(sum(
		case 
			when oi.Discount > 0 then (oi.RRP*0.88) * case when oi.[Action]=106 then oi.VatRate else 1 end --MA requested VAT rate to be multiplied if its a comet card 10/09/08
			else 
				case when oi.Discount < 0 then (oi.Price*oi.VatRate) 
				else 
					case when oi.Discount=0 then oi.Price end 
				end 
			end
	),0) as total
	from SN_PPD3_CometGiftCardDelivery gc
	join SN_PPD3_CometGiftCardItems gci on gci.GCID=gc.GCID
	join SN_PPD3_OrderItems oi on oi.ID=gci.OIID
	join SN_PPD3_Products p on p.ProdID=oi.ProdID and p.Distributor in (6085,6181)
	where gc.Status = 10
	and oi.CreateDate > '20070112' 
	group by oi.ClaimID 

	union
	
	-- Comet Product (Action=107)
	select oi.ClaimID,isnull(sum(
		case 
			when oi.Discount > 0 then (oi.RRP*0.88) * case when oi.[Action]=106 then oi.VatRate else 1 end --MA requested VAT rate to be multiplied if its a comet card 10/09/08
			else 
				case when oi.Discount < 0 then (oi.Price*oi.VatRate) 
				else 
					case when oi.Discount=0 then oi.Price end 
				end 
			end
	),0) as total
				
	from SN_PPD3_OrderItems oi
	join SN_PPD3_Products p on p.ProdID=oi.ProdID and p.Distributor in (6085,6181)
	where oi.[Type]='O' and oi.[Action] = 107
	and oi.CreateDate > '20070112' -- This is the minimum invoice date for CometSS in orderitems
	group by oi.ClaimID 
) x


GO
