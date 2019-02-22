SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_LogFeedback] 
@appid varchar(1), 
@userid varchar(30),
@claimid int, 
@helpful varchar(1), 
@rcode varchar (10),
@feedback varchar (1000)
AS set nocount on

if @claimid <> '' and @userid <> '' 
begin
	insert into AppFB (appid,userid,claimid,helpful,rcode,feedback) 
	values (@appid,@userid,@claimid,case when @helpful = '' then 0 else @helpful end, @rcode,@feedback)

	exec GK_LogEntry @userid,null,null,'10','',@claimid,@appid
end
GO
