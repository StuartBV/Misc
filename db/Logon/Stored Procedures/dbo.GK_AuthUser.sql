SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GK_AuthUser]
	@hash varchar(36)='',
	@ApplicationID int=-1,
	@IP varchar (20)
AS
set nocount on
set transaction isolation level read uncommitted

declare @start datetime,@end datetime,@locked tinyint,@userid varchar(50), @now datetime
set @now = getdate()
	
-- test user = mhtest, clientid = 15 appid for validator2 = 7
-- if the user exists and is allowed to use this app and the user is enabled. Need to also check 
if exists(select * from UserData ud
	join ClientApps ca on ca.cid=ud.clientid
	where ud.Hash=@hash and ud.Enabled=1 and ca.aid=@ApplicationID)
begin
	
	select 
		@start=ca.starttime,
		@end=ca.endtime,
		@locked=ud.[validator_lockedout],
		@userid=ud.[UserName]
	from [ClientApps] ca
	join [UserData] ud on ca.[CID]=ud.[ClientID]
	where ca.[AID]=@ApplicationID and ud.[Hash]=@hash 
	
	if (dbo.[TimeOnly](@now) > @start and (dbo.[TimeOnly](@now) < @end or dbo.TimeOnly(@end) = '1/1/1900'))
	begin
		
		update UserData set LastAuth=@now where [hash]=@hash
		
		select 
			1 valid, 
			u.ClientID,
			username,
			isAdmin,
			Parent,
			isnull(c.InsuranceCoId,-1) [InscoID],
			isnull(ic.[Name],'') InscoName, 
			isnull(co.Channel, c.Channel) channel,
			isnull(c.supplierid,0) supplierid,
			isnull(u.Fname + ' ' + u.Sname,'') as FullName,
			u.[validator_lockedout], 
			@locked
		from UserData u 
		join Clients c on c.[CID] = u.ClientID
		-- modified to allow axa bolton through into Prod Validator MH 25/10/07
		left join ClaimOffices co on co.GroupID=1 and co.clientID=case when c.parent>0 then c.parent else c.cid end
		left join InsuranceCos ic on ic.[id]=c.InsuranceCoId
		where [Hash]=@hash and u.[Enabled]=1 

		if @ApplicationID = 7 and @locked =0
			exec validator2.dbo.LogEntry @vno=0,@claimID=0,@userID=@userID,@type=200,@txt='Login successful'
		
		if @locked=0
			return
	end
end
			
select 0

exec [GK_CheckTime] @hash = @hash
GO
