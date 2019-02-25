SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rep__WeeklyExport] as
set nocount on
declare @command varchar(1000),@sql varchar(1000),@path varchar(100)='\\Exciton\ITReports\OptionsReports\',
	@claimid int,@fullpath varchar(100),@datestr varchar(8), @server varchar(50)=cast(serverproperty('servername') as varchar),
	@bcp varchar(50)='bcp', @CommonCommand varchar(100)

select @datestr=replace(convert(char(10),getdate()-1,103),'/',''), 
	@CommonCommand='" queryout "' +@fullpath + '" -r\n -t\t -c -S'+@server+' -T'

-- Integrity Check Report - IAN COULL 
set @fullpath=@path + 'OptionsIntegrityCheck_COULL' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_COULL @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'coulli1@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''
exec ppd3.dbo.SendMail 'IAN.ALLAN@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''
exec ppd3.dbo.SendMail 'gordon.thomson@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''
exec ppd3.dbo.SendMail 'petriek@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check - Coull','',@fullpath,''

-- Integrity Check Report - AASHISH KHANNA 
set @fullpath=@path + 'OptionsIntegrityCheck_KHANNA' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_KHANNA @headers=1'
set @command=@bcp + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'khanna@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''

-- Integrity Check Report - ADIEL KARTHAK 
set @fullpath=@path + 'OptionsIntegrityCheck_KARTHAK' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_KARTHAK @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'karthaa@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''

-- Integrity Check Report - ANGELA HOLE 
set @fullpath=@path + 'OptionsIntegrityCheck_HOLE' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_HOLE @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'holea@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''

-- Integrity Check Report - PAUL WELLS 
set @fullpath=@path + 'OptionsIntegrityCheck_WELLS' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_WELLS @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'wellsp2@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''

-- Integrity Check Report - PAUL WELLS 2 (Saga / L&E) 
set @fullpath=@path + 'OptionsIntegrityCheck_WELLS2' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_WELLS2 @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'wellsp2@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''

-- Integrity Check Report - COLIN BROWN 
set @fullpath=@path + 'OptionsIntegrityCheck_BROWN' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_IntegrityCheck_BROWN @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'alison.clague@aviva.com ','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''
exec ppd3.dbo.SendMail 'thomas.myers@aviva.com ','noreply@ival.co.uk','System Reports','Options Weekly Integrity Check','',@fullpath,''


-- Invoiced Cards Report 
set @fullpath=@path + 'OptionsInvoicedCards' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_InvoicedCards @headers=1'
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'smitb18@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Invoiced Cards','',@fullpath,''
exec ppd3.dbo.SendMail 'SCOTT.CUNNINGTON@aviva.com','noreply@ival.co.uk','System Reports','Options Weekly Invoiced Cards','',@fullpath,''


-- Argos Options Report 
set @fullpath=@path + 'ArgosOptionsWeeklyVolume' + @datestr + '.xls'
set @sql='exec icards.dbo.Rep_ArgosOptionsWeeklyVolume '
set @command=dbo.BcpCommand() + '"'+ @sql + @CommonCommand

exec master.dbo.xp_cmdshell @command, no_output

exec ppd3.dbo.SendMail 'chris.mansell@ival.co.uk','noreply@ival.co.uk','System Reports','Argos Options Weekly Volume','',@fullpath,''
exec ppd3.dbo.SendMail 'karen.chatters@ival.co.uk','noreply@ival.co.uk','System Reports','Argos Options Weekly Volume','',@fullpath,''
exec ppd3.dbo.SendMail 'laura.williams@ival.co.uk','noreply@ival.co.uk','System Reports','Argos Options Weekly Volume','',@fullpath,''
exec ppd3.dbo.SendMail 'gary.simpson@homeretailgroup.com','noreply@ival.co.uk','System Reports','Argos Options Weekly Volume','',@fullpath,''
exec ppd3.dbo.SendMail 'john.stewart@homeretailgroup.com','noreply@ival.co.uk','System Reports','Argos Options Weekly Volume','',@fullpath,''

GO
