SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LineItemQtyFix]
@MessageID int,
@UserID userid ='sys'
as
set nocount on
set xact_abort on

if exists(select count(*) from Data_Item where MessageID=@messageID having count(*)>=65)
begin
	begin transaction
	
	-- Update last row to be the sum of all rows
	update di set di.[description]='CPL item limit exceeded: ' + x.qty + ' aggregated items.', di.NetPrice=x.NetPrice, di.VatAmount=x.VatAmount
	from 
	Data_Item di join (
		select max(id)Id,sum(NetPrice)NetPrice,sum(VatAmount)VatAmount,cast(count(*) as varchar) Qty
		from Data_Item where MessageID=@messageID
	) x on di.Id=x.Id

	-- delete all but last row

	delete from di
	from data_item di
	where messageID=@messageID and di.id !=(select max(id) from data_item x where x.messageID=di.MessageID)

	-- If message failed, reset to resend
	update MessageQueue.dbo.[Queue] set
		datesent=null,
		RetryCount=0,
		altereddate=getdate(),
		alteredby=@UserID,
		[SysComments]='Reset for sending after aggregate item fix'
	where id=@messageID
	
	commit transaction
end
	
GO
