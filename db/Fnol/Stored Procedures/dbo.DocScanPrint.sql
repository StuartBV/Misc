SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocScanPrint]
@scanID int=0,
@userid UserID
as
set nocount on
set transaction isolation level read uncommitted

select ds.ClaimID, ds.scanID, ds.Sheets, sys.extradescription [group], sys.[description] type,  isnull(e.fname,'Error') + ' ' + isnull(e.sname,' Unknown User') EmpName,
	case when x.ssquote=1 then 1 else 0 end as SSQuote, c.clientrefno DistID
from DocumentScanHeaders ds join DocumentScanHeadersType dst on dst.ScanID=ds.ScanID
join fnol_claims c  on c.claimid=ds.claimid
join ppd3.dbo.syslookup sys on sys.tablename='DocScanType' and sys.flags=dst.DocType
left join ppd3.dbo.Logon l on l.userid=ds.createdby
left join ppd3.dbo.Employees e on l.UserFK=e.[ID]
left join (
	select claimid, count(*) as SSQuote , sys2.Flags as DistID
	from DocumentScanHeaders ds
	join DocumentScanHeadersType dst on dst.ScanID=ds.ScanID 
	join ppd3.dbo.syslookup sys on sys.tablename='DocScanType' and sys.flags=dst.DocType
	join ppd3.dbo.syslookup sys2 on sys2.tablename='SSMap' and sys.code=sys2.code
	where dst.DocType between 200 and 220 and dst.scanid=@scanID and ds.CreatedBy=@userid and ds.Uploaded is null and ds.cancelled is null
	group by ClaimID, sys2.Flags
)x on x.claimid=ds.claimid
where 1=case when ds.scanID=@scanID and ds.uploaded is null and ds.cancelled is null and ds.createdby=@userid then 1 else --pulls details of only one scan header
		case when @scanID=0 and ds.printed is null and ds.cancelled is null and ds.createdby=@userid then 1 else 0 end -- pulls details of all scan headers for said user
	end
order by ds.scanID, sys.Flags

GO
