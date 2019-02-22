SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_LogEntry]
	@userid varchar (30), 
	@password varchar (30),
	@ip varchar (20),
	@code varchar (10),
	@desc varchar (100) = '',
	@claimid int = null,
	@appid varchar(1) = '',
	@alteredby varchar(20) = 'SYS',
	@extracode int = null
AS 
set nocount on
set transaction isolation level read uncommitted

insert into AuthLog (appid,userid,[password],IP,claimid,Code,[Desc],CreatedBy)
values (@appid,@userid,@password,@ip,@claimid,@code,
case @code 	when 0 then 'Successful Login' 
		when 1 then 'Login failed: Password Incorrect'
		when 2 then 'Login failed: Account Disabled'
		when 3 then 'Login failed: Username incorrect/Not Found' 
		when 4 then 'Login failed: Account deleted'
		when 5 then 'Claim: ' + cast(@claimid as varchar) + ' viewed successfully.'
		when 6 then 'Login failed: Account has no access to an application'
		when 7 then 'Login failed: Unauthorised IP or location.'
		when 8 then 'Login failed: IP has Expired.'
		when 9 then 'Login failed: Successful Logout'
		when 10 then 'Feedback left'
		when 11 then 'Successful update of supplied details.'
		when 12 then 'Comet Inspection viewed.'
		when 13 then 'Client Apps updated'
		when 14 then 'Client Details updated'
		when 15 then 'Collection viewed'
		when 16 then 'Validated Items Viewed'
		when 100 then 'User session expired OR illegal page access' else @desc end,
@alteredby)
	
set transaction isolation level read committed
GO
