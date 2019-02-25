SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetLastRef]
@userid varchar(50)
as

set nocount on
/*
<SP>
	<Name>GetLastRef</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20060613</CreateDate>
	<Referenced>
		<asp>/asp/icards/icardsmenu.asp</asp>
	</Referenced>
	<Overview>Called whenever the menu page is loaded to get the last claim looked at by an operator</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
select lastref,lastframe
from lastref
where userid = @userid
GO
