SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[NewBooking]
@FIN varchar(10),
@BookedFor varchar(50),
@Start datetime,
@End datetime,
@Name varchar(50),
@Place varchar(50),
@Phone varchar(50),
@UserID UserID,
@Type varchar(10)
as
set nocount on
declare @ID int,@tier smallint,@claim int,@Originclaim int,@nt varchar(200)

begin tran

insert into Bookings (FIN,BookedFor,StartDate,EndDate,[type],ContactPlace,ContactNo,ContactName,CreateDate,CreatedBy) 
values (@FIN,@BookedFor,@Start,@End,@Type,@Place,@Phone,@Name,getdate(),@UserId)

set @ID=scope_identity()

update Fraud set
	BookingID=@ID,
	ClaimHandler=case when @Type='SCR' then @BookedFor else ClaimHandler end,
	[status]=2,
	AlteredDate=getdate(),
	AlteredBy=@UserID
where FIN=@FIN

if @Type='SCR'
 begin
	select @claim=claimid,@tier=currenttier from fraud where fin=@FIN
	set @nt='Screening Appointment booked for '+@BookedFor+' on '+convert(varchar(12),@Start,13)+' at '+convert(varchar(12),@Start,108)
		+'<br>Contact details: '+@Name+' at '+@Place+' on '+@Phone
	exec AddNoteToClaim @ClaimId=@claim,@note=@nt,@userid=@UserID,@notereason=0
	exec LogEvent @FIN,@BookedFor,@ID,@tier,2,2
	exec UpdateFirstContact_PPD3 @claim
 end
else
 begin
 	exec LogEvent null,@UserID,@ID,null,null,2
 end

commit
GO
