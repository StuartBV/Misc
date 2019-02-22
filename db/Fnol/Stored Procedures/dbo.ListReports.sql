SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ListReports] as

set nocount on

--list of reports
select 1 as seq,'All' as [description],'All' as extradescription
union all
select 2 as seq,[description],extradescription
from syslookup 
where tablename='report'

--list of teams
select 1 seq,'Select' [team],'All' [code]
union all
select 2 seq,sl.[Description] [team],sl.code [code]
from sysLookup sl
where tablename='team'
order by seq,code
GO
