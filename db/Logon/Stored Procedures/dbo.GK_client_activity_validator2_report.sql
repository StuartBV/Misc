SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_client_activity_validator2_report]
@report varchar(20)
as
set nocount on
set transaction isolation level read uncommitted
declare @dt datetime=dateadd(dd,0, datediff(dd,0,getdate()))
--logins

if @report='login'
begin
select x.[Name], x.vno, x.userid, x.[Description] as activity, x.txt as details, x.createdate as createdate  from
(
	select 'A' seq, 'Client Name' [Name], 'VNO' vno, 'Username' userid, 'Activity' [Description], 'Details' txt, 'createdate' Createdate
	union all
	select 'B' seq, c.[Name], cast(l.vno as varchar), l.userid, s.[Description] as activity, l.txt as details, convert(varchar,l.createdate,103) + ' ' +  convert(varchar,l.createdate,108) as createdate  
	from validator2.dbo.[log] l join userdata u on l.userid=u.username
	join clients c on c.cid=u.clientID
	left join validator2.dbo.syslookup s on s.code=l.[type] and s.tablename='LogType'
	where l.createdate > @dt and l.[Type]=200
)x
order by seq, x.NAME
end

-- item details
if @report='item'
begin
select x.[Name], x.vno, x.userid, x.[Description] as activity, x.txt as details, x.createdate as createdate  from
(
	select 'A' seq, 'Client Name' [Name], 'VNO' vno, 'Username' userid, 'Activity' [Description], 'Details' txt, 'createdate' Createdate
	union all
	select 'B' seq, c.[Name], cast(l.vno as varchar), l.userid, s.[Description] as activity, l.txt as details, convert(varchar,l.createdate,103) + ' ' +  convert(varchar,l.createdate,108) as createdate  
	from validator2.dbo.[log] l join userdata u on l.userid=u.username
	join clients c on c.cid=u.clientID
	left join validator2.dbo.syslookup s on s.code=l.[type] and s.tablename='LogType'
	where l.createdate > @dt and l.[Type]=15
)x
order by seq, x.NAME
end

--stage2 - stage 3
if @report='stage'
begin
select x.[Name], x.vno, x.userid, x.[Description] as activity, x.txt as details, x.createdate as createdate  from
(
	select 'A' seq, 'Client Name' [Name], 'VNO' vno, 'Username' userid, 'Activity' [Description], 'Details' txt, 'createdate' Createdate
	union all
	select 'B' seq, c.[Name], cast(l.vno as varchar), l.userid, s.[Description] as activity, l.txt as details, convert(varchar,l.createdate,103) + ' ' +  convert(varchar,l.createdate,108) as createdate
	from validator2.dbo.[log] l join userdata u on l.userid=u.username
	join clients c on c.cid=u.clientID
	left join validator2.dbo.syslookup s on s.code=l.[type] and s.tablename='LogType'
	where l.createdate > @dt and l.[type]=10 and l.txt like '%Stage 2 to Stage 3%'
)x
order by seq, x.NAME
end

-- searches
if @report='search'
begin
select x.[Name], x.vno, x.userid, x.[Description] as activity, x.txt as details, x.createdate as createdate  from
(
	select 'A' seq, 'Client Name' [Name], 'VNO' vno, 'Username' userid, 'Activity' [Description], 'Details' txt, 'createdate' Createdate
	union all
	select 'B' seq, c.[Name], cast(l.vno as varchar), l.userid, s.[Description] as activity, l.txt as details, convert(varchar,l.createdate,103) + ' ' +  convert(varchar,l.createdate,108) as createdate
	from validator2.dbo.[log] l join userdata u on l.userid=u.username
	join clients c on c.cid=u.clientID
	left join validator2.dbo.syslookup s on s.code=l.[type] and s.tablename='LogType'
	where l.createdate > @dt and l.[Type]=20
)x
order by seq, x.NAME
end

GO
