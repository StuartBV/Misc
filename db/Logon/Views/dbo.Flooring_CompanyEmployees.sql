SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Flooring_CompanyEmployees]
as
select ud.[uid], ud.clientid, ud.fname, ud.sname, ud.username, ud.email, ud.CreateDate, ud.CreatedBy, ud.AlteredBy, ud.AlteredDate
from Logon.dbo.userdata ud 
where ud.clientid=189 and ud.deleted='' and ud.[enabled]=1
GO
