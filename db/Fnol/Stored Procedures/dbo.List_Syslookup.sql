SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[List_Syslookup]
@tablename varchar(50),
@order tinyint
AS
set nocount on

declare @sql varchar(500)


set @sql='
Select code, [description], Flags, ExtraCode, ExtraDescription
from Syslookup where tablename='''+@tablename+'''
Order by ' + case @order
		when 1 then 'code'
		when 2 then '[description]'
		when 3 then 'flags'
		when 4 then 'extracode'
		when 5 then 'extradescription' end
--print @sql
exec (@sql)
GO
