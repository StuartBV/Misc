SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[WallBoardLog4Net]
as
set nocount on
select
	case when Portal='BeValued Ordering Service' then 'Ordering' 
	when Portal='BeValued.ETL.Service' then 'ETL'
	when Portal='BeValued.ETL.ServiceV2' then 'ETL V2'
	when Portal='Bevalued.Mvc.Areas.Main' then 'CMS'
	when Portal='BeValued.PRovide.WebService' then 'PRovide WS'
	when Portal='BeValued.Wcf' then 'WCF'	
	when Portal='Communications SERVICE' then 'Coms Sender'
	when Portal='SSO-Security' then 'SSO'
	when Portal='Validator2' then 'Validator 3'
	when Portal='BeValued.PRovide.PlanService' then 'PRovide PS'
	else Portal end Portal, 
count(*) Errors,
'' AS [Message]
from log4net 
where [Date]>getdate()-1 and [level]='ERROR'
group by Portal
UNION ALL
select
	case when Portal='BeValued Ordering Service' then 'Ordering' 
	when Portal='BeValued.ETL.Service' then 'ETL'
	when Portal='BeValued.ETL.ServiceV2' then 'ETL V2'
	when Portal='Bevalued.Mvc.Areas.Main' then 'CMS'
	when Portal='BeValued.PRovide.WebService' then 'PRovide WS'
	when Portal='BeValued.Wcf' then 'WCF'	
	when Portal='Communications SERVICE' then 'Coms Sender'
	when Portal='SSO-Security' then 'SSO'
	when Portal='Validator2' then 'Validator 3'
	when Portal='BeValued.PRovide.PlanService' then 'PRovide PS'
	else Portal end Portal, 
1 AS Errors,
[message] AS [Message]
from log4net 
where [Date]>getdate()-1 and [level]='WARNING'
order by Portal
GO
