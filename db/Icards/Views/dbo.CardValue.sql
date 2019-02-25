SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CardValue] as
select cardid,sum(cardvalue) CardValue
from transactions
where [status]=2
group by cardid
GO
