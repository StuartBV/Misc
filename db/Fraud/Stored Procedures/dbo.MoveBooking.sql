SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MoveBooking]
@BookingId INT,
@sDate DATETIME,
@sAgent VARCHAR(100),
@userid VARCHAR(50)
as
declare
@nt varchar(200),
@claim int

SET NOCOUNT ON
set transaction isolation level read uncommitted

update b
set b.startdate=@sDate, b.enddate=dateadd(mi,datediff(mi,b.startdate,b.enddate),@sDate),
b.BookedFor=@sAgent,b.AlteredBy=@sAgent,b.AlteredDate=GETDATE()
from bookings b 
where b.BookingID=@BookingId

UPDATE f 
SET ClaimHandler=@sAgent,AlteredDate=GETDATE(),AlteredBy=@UserID
from Fraud f   
JOIN bookings b ON f.BookingID = b.BookingID
WHERE f.BookingID=@BookingId
AND b.Type='SCR'

select @nt='Screening Appointment re-arranged for '+BookedFor+' on '+convert(VARCHAR(12),Startdate,13)+' at '+convert(VARCHAR(12),Startdate,108) +'<br>Contact details: '+contactname+' at '+contactplace+' on '+contactno,
@claim=f.claimid
from bookings b  
join fraud f  on b.bookingid=f.bookingid
where b.BookingID=@BookingId

exec AddNoteToClaim @ClaimId=@claim,@note=@nt,@userid=@userid,@notereason=0

set transaction isolation level read committed


GO
