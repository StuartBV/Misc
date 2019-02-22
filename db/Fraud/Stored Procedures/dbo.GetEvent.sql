SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetEvent]
@bookingID int
AS

SET NOCOUNT on
set transaction isolation level read uncommitted

SELECT
b.BookingID,f.FIN,b.startdate,b.enddate,b.contactname name,b.contactplace place,b.contactno phone,
b.BookedFor,b.[Type]
FROM Bookings b  
LEFT JOIN Fraud f  ON b.fin=f.FIN
LEFT join claims cl  on f.claimid=cl.claimid
WHERE b.BookingID=@bookingID

set transaction isolation level read committed

GO
