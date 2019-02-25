SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[NotesInfo]
@iCardsID varchar(50)
as
set nocount on
select 
convert(char(10), c.CreateDate, 103) ccd,c.CreatedBy as ccb,
coalesce (e.FName + ' ' + e.SName, 'Administrator') EmpName,
coalesce (e2.FName + ' ' + e2.SName, 'Administrator') EmpAlteredBy
from notes c
left join ppd3.dbo.Logon l on l.UserID = c.CreatedBy
left join ppd3.dbo.Employees e on e.[Id] = l.UserFK
left join ppd3.dbo.Logon l2 on l2.UserID = c.alteredby
left join ppd3.dbo.Employees e2 on e2.[Id] = l2.UserFK
where iCardsID=@iCardsID
GO
