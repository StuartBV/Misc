SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetUnFinishedCards] 
as
set nocount on

select *
from policysearch
where wizardstage between 1 and 3
and cancelreason is null -- added by Del 17/8/2006
order by seq
GO
