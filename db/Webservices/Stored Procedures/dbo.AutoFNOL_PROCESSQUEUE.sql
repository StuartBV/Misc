SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AutoFNOL_PROCESSQUEUE]
as
set nocount on
set xact_abort on
-- This SP is to be called periodically from a Job

create table #message ([ID] int primary key)
declare @msgID int, @i smallint,@IsError tinyint,@ErrorMsg varchar(1000)

if exists(select * from syslookup where category='AutoFnolProcessQueue' and code=0)	-- Check job not already running
begin
	update syslookup set code=1 where  category='AutoFnolProcessQueue'	-- Set to Running status
	set @i=0
	
	insert into #message([ID])
	select top 100 l.[ID]
	from AUTOFNOL_MessageLog l join AUTOFNOL_Claims c on l.[id]=c.messagelogid
	where l.pushedtoppd3 is null and l.[status]='Received'
	order by l.[id]
		
	while exists (select * from #message) and @i<100	-- Safetycatch/maximum batch size
	begin
		select top 1 @msgID=[ID] from #message
	
		set @i=@i+1	-- Counter used for safety to prevent any case where loop might be infinite
		
		if @msgID is not null
		begin
			exec AutoFNOL_CheckLoadingTables @msgID, @IsError output, @ErrorMsg output
			if @IsError=0 -- ok to process
			 begin 
				exec AUTOFNOL_PushToPPD3 @InstructionId=@msgID
			 end 
			else
			 begin
				if @IsError=99 -- general error so log and send email
				 begin
					exec AutoFNOL_LogError @msgID,@ErrorMsg
				 end 
			 end
		end
		delete from #message where [id]=@msgID
	end
	update syslookup set code=0 where  category='AutoFnolProcessQueue'	-- Set to Idle status
end
else
 begin
	raiserror('ERROR: AutoFNOL thinks its still running!',18,1)
 end

if @@error<>0
begin
	update syslookup set code=0 where category='AutoFnolProcessQueue'	-- Set to Idle status
	
	exec ppd3.dbo.SendMail @Recipient='itsupport@powerplaydirect.co.uk', @SenderEmail='noreply@powerplaydirect.co.uk', @SenderName='AutoFNOL Webservice',
		@Subject='LIVE - AutoFNOL PushToPPD3 Error', @Body='Error Processing AutoFNOL Message Queue'

	raiserror('ERROR: Error Processing AutoFNOL Queue.',18,1)
end
GO
