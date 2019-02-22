SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateBooking]
@FIN VARCHAR(10),
@BookedFor VARCHAR(50),
@Start DATETIME,
@End DATETIME,
@Name VARCHAR(50),
@Place VARCHAR(50),
@Phone VARCHAR(50),
@UserID VARCHAR(50),
@Type VARCHAR(10),
@BookingID int
AS
DECLARE 
@tier smallint,
@claim int,
@newclaim INT,
@oldfin VARCHAR(10),
@nt varchar(200)

SET NOCOUNT ON
set transaction isolation level read uncommitted

BEGIN TRAN

/*get current event details*/
select @claim=f.claimid,@oldfin=f.fin 
from fraud f  
JOIN Bookings b  ON f.BookingID = b.BookingID
where b.BookingID=@BookingID

/*update event details with new info*/
update Bookings 
SET FIN=@fin,BookedFor=@BookedFor,StartDate=@Start,EndDate=@End,[Type]=@Type,
ContactPlace=@Place,ContactNo=@Phone,ContactName=@Name,AlteredDate=GETDATE(),AlteredBy=@UserID
WHERE BookingID=@BookingID

/*get new event details*/
select @newclaim=claimid,@tier=currenttier from fraud where fin=@FIN

IF @oldfin<>@fin --claim no has been changed
 BEGIN
 	/*remove link to old claim*/
	UPDATE fraud SET BookingID=NULL,AlteredDate=GETDATE(),AlteredBy=@UserID where FIN=@oldfin
	/*add link to new claim*/
	UPDATE Fraud SET BookingID=@BookingID,ClaimHandler=case when @Type='SCR' then @BookedFor ELSE ClaimHandler end,status=2,AlteredDate=GETDATE(),AlteredBy=@UserID WHERE FIN=@FIN
	/*add note to old claim*/
	set @nt='Screening Appointment Removed'
	exec AddNoteToClaim @ClaimId=@claim,@note=@nt,@userid=@UserID,@notereason=0
	/*add note to new claim*/
	set @nt='Screening Appointment Made for '+@Name+' on '+convert(VARCHAR(12),@Start,13)+' at '+convert(VARCHAR(12),@Start,108)
	exec AddNoteToClaim @ClaimId=@newclaim,@note=@nt,@userid=@UserID,@notereason=0
	/*log changes*/
	exec LogEvent @FIN,@BookedFor,@BookingID,@tier,2,2
 END
ELSE
 BEGIN
 	IF @Type='SCR' -- event is for a claim
	 BEGIN
	 	set @nt='Booking changed to '+@Name+' on '+convert(VARCHAR(12),@Start,13)+' at '+convert(VARCHAR(12),@Start,108)+' for handler - '+@BookedFor
	 	UPDATE Fraud SET ClaimHandler=case when @Type='SCR' then @BookedFor ELSE ClaimHandler end,status=2,AlteredDate=GETDATE(),AlteredBy=@UserID WHERE FIN=@FIN
		exec AddNoteToClaim @ClaimId=@newclaim,@note=@nt,@userid=@UserID,@notereason=0
 		exec LogEvent @FIN,@BookedFor,@BookingID,@tier,2,2
	 END
	ELSE
	 BEGIN
	 	exec LogEvent null,@BookedFor,@BookingID,null,null,2
	 END
 END

COMMIT

set transaction isolation level read committed


GO
