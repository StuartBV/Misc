SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetNotes] 
@iCardsID varchar(50)
as
/*
<SP>
	<Name>GetNotes</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060518</CreateDate>
	<Referenced>
		<asp></asp>
	</Referenced>
	<Overview>Called from Options systems to display notes when viewing a policy</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
select * from notesview
where icardsid = @iCardsID
order by datesort
GO
