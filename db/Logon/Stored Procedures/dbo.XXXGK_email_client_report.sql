SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[XXXGK_email_client_report]

AS

return 

-- Someone didnt like this report being sent to IT Support so it got turned off
-- Have commented out, and returned cos I dont like it either.
/*
set nocount ON
declare @command varchar(1000),@sql varchar(1000),@path varchar(100),@claimid int,@fullpath varchar(100),@datestr varchar(8)
set @path='\\positron\it\powerplayreports\'
set @datestr=replace(convert(char(10),getdate(),103),'/','')

-- logins
set @fullpath=@path + 'Client_validator2_Activity_logins' + @datestr + '.xls'
set @sql='exec logon.dbo.GK_client_activity_validator2_report @report=''login'''
set @command='c:\winnt\SQLBinn\bcp.exe "'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
--exec master..xp_cmdshell @command, no_output
--exec ppd3..SendMail 'itsupport@powerplaydirect.co.uk','noreply@powerplaydirect.co.uk','System Reports','client validator2 logins','',@fullpath,''

--item details
set @fullpath=@path + 'Client_validator2_Activity_item' + @datestr + '.xls'
set @sql='exec logon.dbo.GK_client_activity_validator2_report @report=''item'''
set @command='c:\winnt\SQLBinn\bcp.exe "'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
--exec master..xp_cmdshell @command, no_output
--exec ppd3..SendMail 'itsupport@powerplaydirect.co.uk','noreply@powerplaydirect.co.uk','System Reports','client validator2 item details','',@fullpath,''

--STAGE2-3
set @fullpath=@path + 'Client_validator2_Activity_STAGE2-3' + @datestr + '.xls'
set @sql='exec logon.dbo.GK_client_activity_validator2_report @report=''stage'''
set @command='c:\winnt\SQLBinn\bcp.exe "'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
--exec master..xp_cmdshell @command, no_output
--exec ppd3..SendMail 'itsupport@powerplaydirect.co.uk','noreply@powerplaydirect.co.uk','System Reports','client validator2 stage2-3','',@fullpath,''

--searches
set @fullpath=@path + 'Client_validator2_Activity_searches' + @datestr + '.xls'
set @sql='exec logon.dbo.GK_client_activity_validator2_report @report=''search'''
set @command='c:\winnt\SQLBinn\bcp.exe "'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
--exec master..xp_cmdshell @command, no_output
--exec ppd3..SendMail 'itsupport@powerplaydirect.co.uk','noreply@powerplaydirect.co.uk','System Reports','client validator2 searches','',@fullpath,''

*/
GO
