SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[reports_channellist] 
as
set nocount on

select 1 as seq,'All' as title,'All' as code
union all
select distinct 2 as seq,channel title,channel code
from claims 
order by seq
GO
