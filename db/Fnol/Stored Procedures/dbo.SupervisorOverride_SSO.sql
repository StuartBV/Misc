SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupervisorOverride_SSO]
@username UserID
as
set nocount on
set transaction isolation level read uncommitted

select case when isnull(l.Team,'')='IT' then 1 else isnull(u.assetoverride,0) end [isValid]
from ppd3.dbo.logon l join ppd3.dbo.employees e on l.userfk=e.Id
left join dbo.Users u on u.UserID = l.UserID
where l.userid=@username

GO
