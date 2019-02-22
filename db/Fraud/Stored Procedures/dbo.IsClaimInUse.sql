SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[IsClaimInUse]
@Claim int,
@userID UserID
as
set nocount on

if exists (select * from fraud where claimid=@claim and alteredby!=@userID and InUse=1)
 begin
	select f.inuse,'Claim is already being viewed by '+E.Fname+' '+E.Sname as msg
	from Fraud f join ppd3.dbo.Logon L on f.alteredby=L.UserID
	join ppd3.dbo.Employees E on E.[ID]=L.UserFK
	where f.claimid=@claim
end
else
begin
	select 0 as inuse,'' as msg	
end
GO
