SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rep__MonthlyExport] AS
set nocount on
declare @command varchar(1000),@sql varchar(1000),@path varchar(100),@claimid int,@fullpath varchar(100),@datestr varchar(8)
set @path='\\Exciton\ITReports\OptionsReports\'
set @datestr=replace(convert(char(10),getdate()-1,103),'/','')
 
-- SEND Daily Options MI
set @fullpath=@path + 'OptionsMonthlyThroughput' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_OptionsMonthlyThroughput @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'
exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'mark.willoughby@ival.co.uk','noreply@ival.co.uk','System Reports','Options Monthly Throughput Report','',@fullpath,''
exec ppd3.dbo.SendMail 'smitb18@aviva.com','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''
exec ppd3.dbo.SendMail 'howard.holmes@aviva.com','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''
exec ppd3.dbo.SendMail 'nuissmi@aviva.com','noreply@ival.co.uk','System Reports','Options Daily Throughput Report','',@fullpath,''
GO
