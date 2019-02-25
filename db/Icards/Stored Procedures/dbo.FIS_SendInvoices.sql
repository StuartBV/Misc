SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[FIS_SendInvoices] as
set nocount on
set xact_abort on
declare @command varchar(1000), @sql varchar(1000), @path varchar(100)='\\exciton\options\invoicelog\', @fullpath varchar(100),
@datestr varchar(8)=replace(convert(char(10),getdate(),103),'/',''), @invoicesent datetime=getdate(), @emailto varchar(200), @batchno varchar(50)

create table #emailaddress (email varchar(200),emailsent tinyint)

-- Email list updated and correct as of 22/10/2013 by SD
insert into #emailaddress ( email,emailsent )
select 'OptionsReports@ival.co.uk',0 union all
select 'mark.willoughby@powerplaydirect.co.uk',0 union all
select 'nishan.gunarathne@aviva.com',0 union all
select 'saadik.mohamed@aviva.com',0 union all
select 'hhcpl@aviva.com',0 union all
select 'harshini.amerasinghe@aviva.com',0 union all
select 'vicki.kelsey@aviva.com',0 union all
select 'claire.homes@aviva.com',0 union all
select 'helen.page@bevalued.co.uk',0


-- CPL events, added by SD 05/07/2010
-- Insert events into ClaimEvents for all cards invoiced on this batch number

insert into ppd3.dbo.ClaimEvents (claimID,[type],actioneddate,actionedby,SupplierID,CreatedBy,data)
select distinct p.IValRef ClaimID,665 [type],@invoicesent,'sys',6500 SupplierID, 'iCards_SendInvoices' CreatedBy,	-- Type: Event 665, making use of non-validated supplier event, Options Cards is a special case
cast(c.[id] as varchar)
from icards.dbo.transactions t							-- Supplier 6500: Special supplierID created for Options Cards to send estimates for CPL
join icards.dbo.cards c on c.[ID]=t.CardID
join icards.dbo.policies p on p.CustomerID=c.CustomerId
join icards.dbo.Icards_InvoiceQueue iq on iq.batchNo=t.InvoiceBatchNo and iq.DateInvoiced is null
where p.ivalRef is not null
and t.CreatedBy!='sys.reissue'

-- load report
set @fullpath=@path + 'ecards_load_batch_' + @datestr + '.xls'
set @sql='exec icards.dbo.FIS_InvoiceExport @reporttype=''ADD'' '
set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -t\t -c -S'+cast(serverproperty('servername') as varchar)+' -T'

exec master.dbo.xp_cmdshell @command, no_output
while exists (select * from #emailaddress where emailsent=0)
begin
	select top 1 @emailto=email from #emailaddress where emailsent=0
	exec ppd3.dbo.SendMail @emailto,'noreply@powerplaydirect.co.uk','Ecards Load Invoice Report','Ecards Load Invoice Report','',@fullpath,''	
	update #emailaddress set emailsent=1 where email=@emailto
end

update #emailaddress set emailsent=0

-- credit report
set @fullpath=@path + 'ecards_credits_batch_' + @datestr + '.xls'
set @sql='exec icards.dbo.FIS_InvoiceExport @reporttype=''SUB'''
set @command=dbo.BcpCommand() + '"'+ @sql +'" queryout "' +@fullpath + '" -r\n -c -t\t -S'+cast(serverproperty('servername') as varchar)+' -T'

exec master.dbo.xp_cmdshell @command, no_output
while exists (select * from #emailaddress where emailsent=0)
begin
	select top 1 @emailto=email from #emailaddress where emailsent=0
	exec ppd3.dbo.SendMail @emailto,'noreply@powerplaydirect.co.uk','Ecards Credits Invoice Report','Ecards Credits Invoice Report','',@fullpath,''
	update #emailaddress set emailsent=1 where email=@emailto
end

-- Update all the records we have just sent with an invoice sent date
update p set InvoicedDate=@invoicesent
from policydetails p join ppd3.dbo.sepsbranches s  on s.accountref=p.SepSCode
join icards.dbo.Icards_InvoiceQueue iq on iq.batchNo=p.InvoiceBatchNo and iq.DateInvoiced is null
where p.[type] in ('B','M') -- B=Add Value to card M=new Card
and p.transdate>='20081103' -- date we started invoicing by excel
and p.companyID=2 	and p.InvoicedDate is null

update dbo.Icards_InvoiceQueue set DateInvoiced=@invoicesent where DateInvoiced is null



drop table #emailaddress
GO
