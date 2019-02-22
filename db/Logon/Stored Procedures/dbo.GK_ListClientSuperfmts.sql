SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_ListClientSuperfmts] 
@cid int
as
set nocount on
set transaction isolation level read uncommitted

declare  @channels varchar(250)    
create table #chan (channel varchar(250) primary key)

select @channels = ','+channel+',' from logon.dbo.clients where cid=@cid

insert into #chan(channel)
select substring(@channels,d.digit+1,charindex(',',@channels,d.digit+1)-d.digit-1) as channel
from ppd3.dbo.Digits d
where d.digit < len(@channels) and substring(@channels,d.digit,1) = ',' 

select distinct csf.SuperFmt, sys.[description]+case when sys.code='j' then ' (Powerplay)' else '' end
from #chan ch join ppd3.dbo.ICE_Categories ic  on isnull(ic.channel,ch.channel)=ch.channel
join (
	select max(coalesce(csf.channel,'')) channel,csf.catid
	from #chan ch join ppd3.dbo.ICE_CategorySuperFmts csf  on ch.channel=isnull(csf.channel,ch.channel)
	group by csf.catid
)x on x.catid=ic.id
join ppd3.dbo.ICE_CategorySuperFmts csf  on ic.id=csf.catid and x.channel=coalesce(csf.channel,'')
join ppd3.dbo.syslookup sys  on sys.tablename='superfmt' and sys.code=csf.superfmt

GO
