SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BatchFileStatusUpdate] 
@cardtype int
as
/*
<SP>
	<Name>BatchFileStatusUpdate</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060612</CreateDate>
	<Referenced>
		<asp>BatchFileErrorUpdate.asp</asp>
	</Referenced>
	<Overview>Used to update the status in the transactions table based on the TSYS batch file process</Overview>
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

update policycardvaluedetails set status = 2, batchfileuploaded=getdate() where status=1 and cardtype = @cardtype
GO
