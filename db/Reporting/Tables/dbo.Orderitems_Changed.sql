CREATE TABLE [dbo].[Orderitems_Changed]
(
[ClaimID] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE trigger [dbo].[Orderitems_Changed_ActionClaimIDs] on [dbo].[Orderitems_Changed] 
for insert
as
--UTC--
set dateformat dmy

-- Get date range of today only
declare @start datetime,@end datetime
set @start=convert(char(10),getdate(),103)
set @end=dateadd(ss,86399,@start)

--capture claims with changed orderitems committed today only
insert into orderitemsStackAggregates_Changed
select distinct i.claimID
from inserted i join SN_PPD3_Orders o (nolock) on o.claimid=i.claimid
and o.activationdateUTC between @start and @end

GO
EXEC sp_addextendedproperty N'MS_Description', N'Captures changed/inserted rows from ppd3.orderitems table', 'SCHEMA', N'dbo', 'TABLE', N'Orderitems_Changed', 'COLUMN', N'ClaimID'
GO
