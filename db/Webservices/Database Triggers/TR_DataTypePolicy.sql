SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [TR_DataTypePolicy] on database for CREATE_TABLE, ALTER_TABLE
as
declare @eventdata as xml, @tablename as sysname, @schemaname as sysname

set @eventdata = eventdata();
set @tablename = cast(@eventdata.query('data(//ObjectName)') as sysname);
set @schemaname = cast(@eventdata.query('data(//SchemaName)') as sysname);

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = @schemaname and TABLE_NAME = @tablename and DATA_TYPE='nvarchar')
begin
	raiserror('Please use varchar NOT nvarchar',16,1)
	rollback
end

GO
