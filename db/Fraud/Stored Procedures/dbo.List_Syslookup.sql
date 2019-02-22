SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
<SP>
	<Name>List_syslookup</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080317</CreateDate>
	<Overview>used to list a set of values from syslookup table</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[List_Syslookup]
@tablename varchar(50),
@order tinyint
AS
set nocount on

declare @sql varchar(500), @where varchar(500)

set @where = ''

set @sql='
Select code, [description], Flags, ExtraCode, ExtraDescription
from Syslookup where tablename= '+ '''' + @tablename + ''''
+@where+'
Order by ' + case @order
		when 1 then 'code'
		when 2 then '[description]'
		when 3 then 'flags'
		when 4 then 'extracode'
		when 5 then 'extradescription' end
exec (@sql)
GO
