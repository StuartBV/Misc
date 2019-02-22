SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[InvoiceBordereau_AXACVCA] 
@path varchar(100),
@from varchar(10),
@to varchar(10)
as
set nocount on
set nocount on
set dateformat dmy
declare @command varchar(1000),@sql varchar(1000), @fullpath varchar(100),@datestr varchar(8), @server varchar(50)

select @path=case dbo.servertype() when 'dev' then ppd3.dbo.LocalPath() else @path end,
	@datestr=replace(convert(char(10),getdate(),103),'/',''),
	@server=cast(serverproperty('servername') as varchar)

	select @fullpath=@path + 'InvoiceBordereau_AXACVCA_' + @datestr + '.xls'
	

set @sql='exec ppd3.dbo.genrep_AXA_V2Orders_IncCMS' + ' @from=''' + convert(char(8),cast(@from as datetime),112) + ''',@to=''' + convert(char(8),cast(@to as datetime),112) + ''''
set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+ @server +' -T -CACP'
--print @sql
--print @command
exec master..xp_cmdshell @command, no_output

GO
