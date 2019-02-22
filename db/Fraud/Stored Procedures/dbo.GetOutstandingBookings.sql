SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
<SP>
	<Name>GetOutstandingBookings</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080409</CreateDate>
	<Overview>Returns list of claims awaiting booking - used in dropdownlist when creating a new booking</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[GetOutstandingBookings]
AS
BEGIN
	
SET NOCOUNT ON
set transaction isolation level read uncommitted

SELECT f.FIN,cast(cl.ClaimNo as varchar)+' - '+cu.lname+', '+cu.Title+' '+LEFT(cu.fname,1) +' - ' +cu.Postcode listname
FROM fraud f  
JOIN claims cl  ON f.ClaimID = cl.ClaimID
JOIN Customers cu  ON cu.ID=cl.CustID
WHERE f.DateClosed IS NULL AND f.status=1
END

set transaction isolation level read committed

GO
