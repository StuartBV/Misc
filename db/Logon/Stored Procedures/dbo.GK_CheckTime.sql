SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_CheckTime]
@hash varchar(36)=''
as
set nocount on
set transaction isolation level read uncommitted

declare @start datetime, @end datetime, @validationcnt int, @userid UserID, 
		@enabled tinyint, @validations int, @searches int, @searchcnt int, @nextsearchtime datetime, 
		@nextvalidationtime datetime, @duration int, @reason varchar(11), @lockedout tinyint, @itemdetailscnt int, @itemdetails int

declare @now datetime=getdate(), @validatorApplicationId int=7

-- Obtain Security Context for Validator2 for Client Specific Login
select @start=ca.starttime,@end=ca.endtime, @userid=ud.UserName,@validations=ca.validations, @searches=ca.searches, @duration=ca.duration, 
@lockedout=ud.validator_lockedout,@itemdetails=ca.Itemdetails
from ClientApps ca join UserData ud on ca.CID=ud.ClientID
where ca.AID=@validatorApplicationId and ud.[hash]=@hash 

select @validationcnt=count(*) 
from validator2.dbo.[log] 
where ([type]=10 and txt like '%Stage 2 to Stage 3%') 
	and userid=@userid and createdate<@now and createdate>dateadd(mi,-@duration,@now)

select @searchcnt=count(*) 
from validator2.dbo.[log] 
where [type]=20 	and userid=@userid and createdate<@now and createdate>dateadd(mi,-@duration,@now)

select @itemdetailscnt=count(*) 
from validator2.dbo.[log] 
where [type]=15 and userid=@userid and createdate<@now and createdate>dateadd(mi,-@duration,@now)

if @validationcnt>@validations or @searchcnt>@searches or @itemdetailscnt>@itemdetails or dbo.Timeonly(@now)<@start 
	or (dbo.Timeonly(@now)>@end and dbo.TimeOnly(@end)>'1/1/1900') 
begin
	if @validationcnt>@validations
	begin
		update UserData set validator_lockedout=1 where [hash]=@hash
		set @lockedout=1
	end
	if @searchcnt>@searches
	begin
		update UserData set validator_lockedout=2 where [hash]=@hash
		set @lockedout=2
	end
	if @itemdetailscnt>@itemdetails
	begin
		update UserData set validator_lockedout=3 where [hash]=@hash
		set @lockedout=3
	end
	if dbo.Timeonly(@now)<@start
	begin
		set @reason='early'
	end
	if dbo.Timeonly(@now)>@end
	begin
		set @reason='late'
	end
	set @enabled=0
end
else
begin
	set @enabled=1
end

if @lockedout=1
begin
	set @reason='validations'
	set @enabled=0
end
if @lockedout=2
begin
	set @reason='searches'
	set @enabled=0
end
if @lockedout=3
begin
	set @reason='itemdetails'
	set @enabled=0
end

select convert(varchar,@end,108) as endtime, convert(varchar,@start,108) as starttime, @enabled as [enabled], @validations as validations, 
@searches as searches, @reason as reason,@validationcnt as validationscount, @searchcnt as searchcount, @duration as duration, 
@lockedout as lockedout, @itemdetailscnt as itemdetailscnt, @itemdetails as itemdetails
GO
