SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Derek Francis>
-- Create date: <8 Aug 2008>
-- Description:	<General procedure used with AJAX calls to update form fields during DataEntry>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDB]
	@id VARCHAR(20),
	@tbl VARCHAR(10),
	@fld VARCHAR(50),
	@value varchar(1000),
	@isnumeric bit,
	@userid varchar(20)
AS
BEGIN
	set QUOTED_IDENTIFIER Off
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	declare @sql nvarchar(4000), @tblname varchar(100), @keyfield varchar(50)
	
	select @tblname=description,@keyfield=extracode from syslookup where tablename='cms-table' and code=@tbl
	
    set @sql="
	update cp
		set cp.[" + @fld + "]=" + 
			case when @isnumeric=1
				then @value
				else "'" + @value + "'"
			end + ",
		cp.alteredby='" + @userid + "',
		cp.altereddate=getdate()
	from [" + @tblname + "] cp (nolock)
	where cp." + @keyfield + "=" + @id 
	
	--print @sql
	exec sp_executesql @sql
	
END

GO
