SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[iCards_GetSEPSBatchNo]
AS
/*
<Notation>
	<Name>iCards_GetSEPSBatchNo</Name>
	<CreatedBy>Mark Perry</CreatedBy>
	<CreateDate>20060512</CreateDate>
	<Referenced>
		<asp>Webservice</asp>
	</Referenced>
	<Overview>Called from tsys seps invoicing to retrieve batch no</Overview>
	<Changes>
		<Change>
			<User>Stu</User>
			<Date>20060517</Date>
			<Comment>code is a char column so casting should be applied for math operation</Comment>
		</Change>
	</Changes>
</Notation>
*/
-- Update the batch number increasing it by one
update syslookup set Code=cast(cast(Code as int)+1 as varchar) where Tablename='InvoiceBatchNo'

-- Select out the newly created batch no
select code from Syslookup where Tablename='InvoiceBatchNo'
GO
