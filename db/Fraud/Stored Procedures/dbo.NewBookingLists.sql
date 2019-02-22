SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
<SP>
	<Name>NewBookingLists</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080415</CreateDate>
	<Overview>used to populate dropdownlists on new booking screen</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[NewBookingLists]
AS

SET NOCOUNT ON

exec ListFraudMembers
exec GetOutstandingBookings
EXEC List_Syslookup 'eventtime',3
EXEC List_Syslookup 'eventplace',3
GO
