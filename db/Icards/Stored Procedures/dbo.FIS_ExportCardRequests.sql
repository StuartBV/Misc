SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[FIS_ExportCardRequests]
as
set nocount on
set xact_abort on
set datefirst 1
set dateformat dmy
declare @command varchar(1000),@sql varchar(1000),@path varchar(100),@fullpath varchar(100),@datestr varchar(10),@servername varchar(100),
@dt datetime=getdate(), @dailyseq varchar(2),@batchref_load varchar(50),@batchref_adj varchar(50),@logtxt varchar(100), @folder varchar(20), @archivepath varchar(100)

set @folder=case dbo.servertype() when 'dev' then 'fistest' else 'fis' end
select @path='\\Exciton\ftp\' + @folder + '\transmit\', @archivepath='\\Exciton\ftp\' + @folder + '\archive\'
select @datestr=right(datepart(yy,@dt),2) + right('0'+cast(month(@dt) as varchar),2) + right('0'+datename(dd,@dt),2), @servername=cast(serverproperty('servername') as varchar(50))


if exists (select * from FIS_Data where [type] in ('R','Z','C','M'))
begin	

	select @dailyseq=right('0' + code,2) from syslookup where tablename='FISDailyRequestSequence'

	set @batchref_load = @datestr +'-'+@dailyseq

	update SysLookup set Code=Code+1 where TableName='FISDailyRequestSequence'

	update t set t.InvoiceBatchNo=@batchref_load, t.AlteredDate=@dt, t.Alteredby='sys'
	from FIS_Data d
	join Transactions t on d.TransactionId=t.ID
	where d.[type] in ('R','Z','C','M')

	insert into Icards_InvoiceQueue (batchNo) values (@batchref_load)

	set @fullpath=@path + 'crdreq' + @datestr + @dailyseq +'.xml'
	set @sql='exec icards.dbo.FIS_ExportCardRequests_XmlData @batchref='''+@batchref_load+''''
	set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -c -S'+@servername+' -T'
	exec master.dbo.xp_cmdshell @command

	set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' + @archivepath + 'crdreq' + @datestr +@dailyseq +'.xml'+'" -r\n -c -S'+@servername+' -T'
	exec master.dbo.xp_cmdshell @command

	update t set
		t.[status]=2,
		t.BatchFileUploaded=@dt
	from FIS_Data d join Transactions t on d.TransactionId=t.ID
	where d.[type] in ('R','Z','C','M') and t.InvoiceBatchNo=@batchref_load

	set @logtxt='SP_FIS_ExportCardRequests RZCM @batchref=' + @batchref_load
	insert into log (CreateDate, UserID, [type], [text])
	values (@dt, 'sys','30',@batchref_load)
end

if exists (select * from FIS_Data where [type]='B')
begin
	select @dailyseq=right('0' + code,2)
	from syslookup where tablename='FISDailyAdjustmentSequence'

	set @batchref_adj = @datestr +'-'+@dailyseq

	update SysLookup set Code=Code+1 where TableName='FISDailyAdjustmentSequence'

	update t set
		t.InvoiceBatchNo=@batchref_adj,
		t.AlteredDate=@dt,
		t.Alteredby='sys'
	from FIS_Data d join Transactions t on d.TransactionId=t.ID
	where d.[type] in ('B')

	insert into Icards_InvoiceQueue (batchNo) values (@batchref_adj)

	set @fullpath=@path + 'baladj' + @datestr + @dailyseq +'.xml'
	set @sql='exec icards.dbo.FIS_ExportBalanceAdjustments @batchref='''+@batchref_adj+''''
	set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -c -S'+@servername+' -T'
	exec master.dbo.xp_cmdshell @command

	set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' + @archivepath + 'crdreq' + @datestr + @dailyseq +'.xml'+'" -r\n -c -S'+@servername+' -T'
	exec master.dbo.xp_cmdshell @command

	update t set
		t.[status]=2,
		t.BatchFileUploaded=@dt
	from FIS_Data d
	join Transactions t on d.TransactionId=t.ID
	where d.[type] in ('B') and t.InvoiceBatchNo=@batchref_adj
	
	set @logtxt='SP_FIS_ExportCardRequest B @batchref=' + @batchref_adj
	insert into log (CreateDate, UserID, [type], [text])
	values (@dt, 'sys','30',@batchref_adj)
end
GO
