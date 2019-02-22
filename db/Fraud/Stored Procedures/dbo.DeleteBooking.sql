SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[DeleteBooking]
@BookingID INT,
@UserID VARCHAR(50)
AS
DECLARE
@fin VARCHAR(50)

SET NOCOUNT ON
set transaction isolation level read uncommitted

exec LogEvent null,@UserID,@BookingID,null,null,90

BEGIN TRAN	

	UPDATE f 
	SET f.bookingid=NULL
	FROM fraud f 
	JOIN bookings b ON f.bookingid = b.bookingid
	WHERE b.bookingid=@BookingID

  	update b 
	set b.deleteddate=getdate(),b.deletedby=@UserID
	FROM bookings b 
	WHERE b.bookingID=@BookingID
			
COMMIT

set transaction isolation level read committed


GO
