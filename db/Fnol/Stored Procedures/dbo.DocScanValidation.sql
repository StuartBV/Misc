SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocScanValidation]
@type int,
@claimid int
as
set nocount on

-- Check Sheets against request
if @type=1
begin
	select claimID, sheets, isnull(e.fname,'user') + '.' + isnull(e.sname,'uknown') empname
	from DocumentScanHeaders d
	left join ppd3.dbo.Logon l on l.userid=d.createdby
	left join ppd3.dbo.Employees e on l.UserFK=e.[ID]
	where uploaded is null and cancelled is null and claimid=@claimid
end
GO
