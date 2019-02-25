SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ModifyiCardDetails]
@iCardsID varchar(10),
@name varchar(50),
@value varchar(50),
@userID varchar(20)=''
AS

set nocount on
DECLARE @ID int
if @userID=''
begin
	raiserror('No username present. Please ensure you are logged in!',18,1)
	return
end

declare @sql nvarchar(1000)
begin tran

if left(@name,6) = 'cards_'  ---Meaning that there was a change on the Cards details section *Please stick to this convention*
begin
	
	SET @name= SUBSTRing(@name,charindex('_',@name)+1,20) ---basically used to get extract info to the right of the underscore
	--Get the ID of the card
	Select @ID = [ID] from Customers where iCardsID=right(@iCardsID,6)
	--print right(@iCardsID,6)
	set @sql="update Cards set "+@name+"='"+@value+"' where CustomerID="+right(@ID,6)+""
	
	
end
else
begin
	set @sql="update Customers set "+@name+"='"+@value+"' where iCardsID='"+right(@iCardsID,6)+"'"
end
--print  @name
 
insert into [Log] (iCardsID, CreateDate, UserID,Type,[Text]) 
values (@iCardsID, getdate(), @UserID, '9', 'Policy Holder details amended: '+@name+' set to '+@value)

--SELECT @sql
exec (@sql)

commit tran
GO
