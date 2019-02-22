SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
<SP>
	<Name>UpdBooking</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080327</CreateDate>
	<Overview>used to update booking information during the interview process</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[UpdBooking]
@FIN VARCHAR(10),
@UserID VARCHAR(50),
@IsContact SMALLINT,
@Reason varchar(50)=null	
AS
declare
@nt varchar(500),
@claimid int

SET NOCOUNT ON
set transaction isolation level read uncommitted

UPDATE b 
SET ContactMade=@IsContact,NoContactReason=@Reason,AlteredDate=GETDATE(),AlteredBy=@UserID,
contactattempts=case when @IsContact=0 then contactattempts+1 else contactattempts END
FROM bookings b  JOIN fraud f  ON b.BookingID = f.BookingID
WHERE f.FIN=@FIN

/*reset fraud case to awaiting booking if contact not made with customer*/
IF @IsContact=0 
BEGIN
	update fraud set status=1, bookingid=null where fin=@FIN
	
	select @claimid=f.claimid from fraud f where f.fin=@FIN
	
	select @nt='Screening contact attempt failed because '+description
	from sysLookup where tablename='reason' and code=@Reason
	
	exec AddNoteToClaim @ClaimId=@claimid,@note=@nt,@userid=@UserID,@notereason=0	
END

set transaction isolation level read committed

GO
