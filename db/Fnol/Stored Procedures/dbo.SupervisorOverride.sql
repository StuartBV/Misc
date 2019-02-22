SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupervisorOverride]
@username UserID,
@password varchar(50)
as
set nocount on
set transaction isolation level read uncommitted

select case when isnull(l.Team,'')='IT' then 1 else isnull(u.assetoverride,0) end as Valid
from ppd3.dbo.logon l
join ppd3.dbo.employees e on l.userfk=e.Id
left join dbo.Users u on u.UserID = l.UserID
where l.userid=@username
and l.[password]=ppd3.dbo.Encrypt(@password)

GO
