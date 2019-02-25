SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[FIS_BalanceAdjustment]
@ICardsID varchar(50),
@value money,
@userid varchar(20)='sys'

AS
set transaction isolation level read uncommitted

DECLARE @text varchar(100)

BEGIN TRAN
	-- Inserts details into the transactions table for a new value to be added to the card
	insert into transactions (cardID, cardvalue, type, status, authrequirement, createdate, createdby)
	select c.cardid, @value, 'B', 1, 0, getdate(), @userid
	from dbo.PolicyCardDetails c
	where c.iCardsID=@ICardsID

	-- Adds a logged event
	IF @value>0
	begin
		insert into [Log] (iCardsID, CreateDate, UserID,Type,[Text]) 
		select @iCardsID, getdate(), @userid, '20', 'New value added to card (' + cast(c.cardid AS varchar) + ') : £'+cast(@value AS varchar)
		from dbo.PolicyCardDetails c
		where c.iCardsID=@ICardsID
	end
	ELSE
	begin
		insert into [Log] (iCardsID, CreateDate, UserID,Type,[Text]) 
		select @iCardsID, getdate(), @userid, '23', 'New value deducted from card (' + cast(c.cardid AS varchar) + ') : £'+cast(@value AS varchar)
		from dbo.PolicyCardDetails c
		where c.iCardsID=@ICardsID
	end

COMMIT TRAN


set transaction isolation level read committed



GO
