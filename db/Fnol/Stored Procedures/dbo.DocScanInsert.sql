SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocScanInsert]
@claimid int,
@sheets smallint,
@userid UserID,
@documents varchar(50),
@communication varchar(50),
@QuoteDetail varchar(50)=''
as
set nocount on

declare @str varchar(50), @charpos int, @scanID int--, @logmsg varchar(500)=''
/*
set @charpos = charindex(',',@str)
while @charpos>0
begin
	select @logmsg=@logmsg + [description] + ', ' 
	from ppd3.dbo.sysLookup
	where tablename='DocScanType' and flags=replace(left(@str,@charpos-1),' ','')

	set @str=right(@str,len(@str)-(@charpos))
	set @charpos = charindex(',',@str)
end

set @logmsg = left(@logmsg,len(@logmsg)-1)
*/
set @str = @documents + @communication + @QuoteDetail

-- Dropped where printed is null to stop user creating multiple scan headers for same claim before upload
if exists (select * from DocumentScanHeaders where uploaded is null and Cancelled is null and claimid=@claimid and createdby=@userid)
begin
	select @scanID=scanID from DocumentScanHeaders
	where claimid=@claimid and createdby=@userid and (printed is null or uploaded is null) and Cancelled is null	-- Bracketing amended here by DF, 20131017

	update DocumentScanHeaders set sheets=@sheets, createdate=getdate()
	where scanID=@scanID

	delete DocumentScanHeadersType where scanID=@scanID

	set @charpos = charindex(',',@str)
	while @charpos>0 and left(@str,@charpos-1)!=0
	begin
		insert into DocumentScanHeadersType (ScanID, DocType)
		select @scanid, left(@str,@charpos-1)
		set @str=right(@str,len(@str)-(@charpos))
		set @charpos = charindex(',',@str)
	end

end
else
begin
	insert into DocumentScanHeaders (ClaimID, Sheets, createdate, createdby)
	select @claimid, @sheets, getdate(), @userid

	set @scanID=scope_identity()

	set @charpos = charindex(',',@str)
	while @charpos>0 and left(@str,@charpos-1)!=0
	begin
		insert into DocumentScanHeadersType (ScanID, DocType)
		select @scanID, left(@str,@charpos-1)
		set @str=right(@str,len(@str)-(@charpos))
		set @charpos = charindex(',',@str)
	end
end
GO
