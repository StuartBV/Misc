SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[reports_teamlist] 
as
set nocount on

select 1 as seq,'All' as title,'All' as [code]
union all
select 2 as seq,[description] [title],code [code]
from sysLookup
where TableName='team'
and code<>'0'
order by seq
GO
