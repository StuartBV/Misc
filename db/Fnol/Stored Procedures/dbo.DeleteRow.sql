SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Derek Francis>
-- Create date: <10 Oct 2008>
-- Description:	<General procedure used  to deleting rows during DataEntry>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteRow]
	@id VARCHAR(20),
	@tbl VARCHAR(10)
AS
set QUOTED_IDENTIFIER Off
BEGIN
	set QUOTED_IDENTIFIER Off
	SET NOCOUNT ON;

	declare @sql nvarchar(1000), @tblname varchar(100), @keyfield VARCHAR(50)
	
	select @tblname=description,@keyfield=extracode from syslookup where tablename='cms-table' and code=@tbl
	
    set @sql="DELETE from [" + @tblname + "] where " + @keyfield + "=" + @id 

	exec sp_executesql @sql
	
END
GO
