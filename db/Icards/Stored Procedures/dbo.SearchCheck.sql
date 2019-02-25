SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[SearchCheck]
@iCardsID varchar(50)
as
/*
<SP>
	<Name>SearchCheck</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060607</CreateDate>
	<Referenced>
		<asp>/asp/icards/seachcheck.asp</asp>
	</Referenced>
	<Overview>Called from searchcheck.asp to identify if claim is locked before returning search results</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
set nocount on

select status from policies where icardsid = right(@iCardsID,6)
GO
