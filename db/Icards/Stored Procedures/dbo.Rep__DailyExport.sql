SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rep__DailyExport] as
set nocount on
declare @command varchar(1000),@sql varchar(1000),@path varchar(100),@claimid int,@fullpath varchar(100),@datestr varchar(8)
set @path='\\Exciton\ITReports\OptionsReports\'
set @datestr=replace(convert(char(10),getdate()-1,103),'/','')

-- SEND Daily Options MI 
-- Daily Throughput Report 
set @fullpath=@path + 'OptionsDailyThroughput' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_OptionsDailyThroughput @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'mark.willoughby@ival.co.uk','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''
--exec ppd3.dbo.SendMail 'smitb18@aviva.com','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''
--exec ppd3.dbo.SendMail 'harrii3@aviva.com','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''
--exec ppd3.dbo.SendMail 'katherine.thompson@aviva.com','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''


/*
-- Still used??
-- Daily Cards by Clearups Report
set @fullpath=@path + 'OptionsClearupCards' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_CardsByClearup @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'jason@ival.co.uk','noreply@ival.co.uk','System Reports',' Cards by iVal Clearup','',@fullpath,''
*/

GO
