SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsNewTransaction]
@CardID int,
@action int,
@value money=0,
@userid UserID,
@reason varchar(250)=''
as
set transaction isolation level read uncommitted

declare @iCardsID varchar(10), @text varchar(100), @transactionID int, @dt datetime=getdate()

if @action=1
begin
begin tran
	-- Inserts details into the transactions table for a new value to be added to the card
	insert into transactions (cardID, cardvalue, type, status, authrequirement, createdate, createdby,Adjustmentreason)
	select @CardID, @value, 'B',0,0,@dt, @userid,@reason
	from cards c join customers cu on cu.ID=c.customerID
	where c.ID=@CardID

	select @transactionID=scope_identity()

	update t set 
		[status]=case when dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)=0 then 1 else 0 end,
		authrequirement=dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)
	from PolicyDetails t
	where t.transactionID=@transactionID

	-- Adds a logged event
	if @value>0
	begin
		select @iCardsID=cc.ClaimNoPrefix + cast(cu.iCardsID as varchar), @text= 'New value added to card (' + cast(@CardID as varchar) + ') : £'+cast(@value as varchar)
		from cards c join customers cu on cu.ID=c.CustomerID
		join policies p on p.customerID=cu.ID
		join card_companies cc on cc.ID=p.CompanyID
		where C.ID=@CardID

		insert into [log] (iCardsID, CreateDate, UserID,[type],[text]) 
		values (@iCardsID, @dt, @userid, '20', @text)
	end
	else
	begin
		select @iCardsID=cc.ClaimNoPrefix + cast(cu.iCardsID as varchar), @text= 'New value deducted from card (' + cast(@CardID as varchar) + ') : £'+cast(@value as varchar)
		from cards c join customers cu on cu.ID=c.CustomerID
		join policies p on p.customerID=cu.ID
		join card_companies cc on cc.ID=p.CompanyID
		where C.ID=@CardID

		insert into [log] (iCardsID, CreateDate, UserID,type,[text]) 
		values (@iCardsID, @dt, @userid, '23', @text)
	end
commit tran

end

if @action=2
begin
begin tran
	-- Inserts details into the transactions table for a new value to be added to the card
	insert into transactions (cardID, cardvalue, [type], [status], authrequirement, createdate, createdby,Adjustmentreason)
	select @CardID, @value, 'B',0,0,@dt, @userid,@reason
	from cards c join customers cu on cu.ID=c.customerID
	where c.ID=@CardID

	select @transactionID=scope_identity()

	update t set
		[status]=case when dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)=0 then 1 else 0 end,
		authrequirement=dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)
	from dbo.PolicyDetails t
	where t.transactionID=@transactionID

	-- Adds a logged event for each new transaction
	select @iCardsID=cc.ClaimNoPrefix + cast(cu.iCardsID as varchar),
		@text= 'New value added to card (' + cast(@CardID as varchar) + ') : £'+cast(@value as varchar)+' | Card (' + cast(@CardID as varchar) + ') : REISSUED'
	from cards c join customers cu on cu.ID=c.CustomerID
	join policies p on p.customerID=cu.ID
	join card_companies cc on cc.ID=p.CompanyID
	where C.ID=@CardID

	insert into [log] (iCardsID, CreateDate, UserID,[type],[text]) 
	values (@iCardsID, @dt, @userid, '21', @text)
commit

end

if @action=3
begin
begin tran
	-- Inserts details into the transactions table for a replacement card to be sent to the ph
	insert into transactions (cardID, [type], [status], createdate, createdby,Adjustmentreason)
	select @CardID, 'R',0,@dt, @userid,@reason
	from cards c join customers cu on cu.ID=c.customerID
	where c.ID=@CardID

	select @transactionID=scope_identity()

	update t set
		[status]=case when dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)=0 then 1 else 0 end,
		authrequirement=dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)
	from dbo.PolicyDetails t
	where t.transactionID=@transactionID

	-- Adds a logged event for each new transaction
	select @iCardsID=cc.ClaimNoPrefix + cast(cu.iCardsID as varchar), @text= 'Card (' + cast(@CardID as varchar) + ') : REISSUED'
	from cards c join customers cu on cu.ID=c.CustomerID
	join policies p on p.customerID=cu.ID
	join card_companies cc on cc.ID=p.CompanyID
	where C.ID=@CardID

	insert into [log] (iCardsID, CreateDate, UserID,[type],[text]) 
	values (@iCardsID, @dt, @userid, '22', @text)
commit tran 
end

if @action=6
begin

begin tran
	-- Inserts details into the transactions table for updating FIS of change to customer details
	insert into transactions (cardID, [type], [status], createdate, createdby)
	select @CardID, 'C',0, @dt, @userid
	from cards c join customers cu on cu.ID=c.customerID
	where c.ID=@CardID

	select @transactionID=scope_identity()

	update t set
		[status]=case when dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)=0 then 1 else 0 end,
		authrequirement=dbo.AuthRequirement(t.postcode,@transactionID,t.CardValue)
	from dbo.PolicyDetails t
	where t.transactionID=@transactionID

	-- Adds a logged event for each new transaction
	select @iCardsID=cc.ClaimNoPrefix + cast(cu.iCardsID as varchar), @text= 'Customer Details amended for Card (' + cast(@CardID as varchar) + ')'
	from cards c join customers cu on cu.ID=c.CustomerID
	join policies p on p.customerID=cu.ID
	join card_companies cc on cc.ID=p.CompanyID
	where C.ID=@CardID

	insert into [log] (iCardsID, CreateDate, UserID,[type],[text]) 
	values (@iCardsID, @dt, @userid, '9', @text)
commit tran 

end
GO
