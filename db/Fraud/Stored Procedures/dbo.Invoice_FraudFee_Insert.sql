SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_FraudFee_Insert]
@claimid int
as
set nocount on
set xact_abort on

declare @dt datetime=getdate(), @feetype tinyint, @invoicetype tinyint, @FeeFormatType varchar(50), @wizardstatus smallint, @status smallint
create table #claim (ClaimID int, channel varchar(50),Feetype tinyint, FraudScreeningInvoiceType tinyint, Gross smallmoney, Net smallmoney, Vat smallmoney,SendMessage tinyint)

select @feetype=flags, @FeeFormatType=ExtraCode from sysLookup where tablename='FeeTypes' and code='FraudScreening'
select @status=c.[status], @wizardstatus=c.WizardStatus from ppd3.dbo.claims c where c.claimid=@claimid

begin tran
	-- Obtain invoice type and Fee Type
	insert into #claim(ClaimID, channel, Feetype, FraudScreeningInvoiceType, Gross, Net, Vat, SendMessage)
	select  c.claimid,c.channel,@feetype,ch.FraudScreeningInvoiceType,p.CostPrice as Gross,
		p.CostPrice / p.VatRate as Net,p.CostPrice - (p.CostPrice / p.VatRate) as Vat,
		ppd3.dbo.InvoiceSendMethod_For_AXA (c.claimid)
	from ppd3.dbo.claims c
	join ppd3.dbo.channels ch on ch.channel=c.channel and ch.ChargeFraudScreeningFee=1 and ch.fraudscreeninginvoicetype=0 -- Bordereau invoicing only
	join ppd3.dbo.products p on p.format='FEES' and p.formattype=@FeeFormatType and p.class=c.channel
	join claims fc on fc.OriginClaimID=c.claimid
	join fraud fd on fd.ClaimID=fc.ClaimID and fd.OriginatingSys='PPD3' 
	left join Fees f on f.claimid=c.claimid and f.FeeType=@feetype
	where c.claimid=@claimid and f.ClaimID is null

	-- Insert Event into ClaimEvents for Fraud Fee
	if exists (
		select * from #claim c join ppd3.dbo.ClaimEvents_IncludeByChannel cec on cec.Channel=c.channel and cec.EventID=685 -- Fraud Fee
		where c.claimid=@claimid and c.SendMessage=1
	)
	begin
		exec ppd3.dbo.ClaimEvents_InsertEvent @claimid=@claimid,@eventtype=685,@userid='Invoice_FraudFee_Insert',@startdate=@dt,@actioneddate=@dt
	end

	-- Insert actual Fee
	insert into dbo.Fees (ClaimID,Channel,FeeType,InvoiceType,Gross,Net,Vat,InvoiceSent,CreateDate,CreatedBy) 
	select ClaimID, channel, Feetype, FraudScreeningInvoiceType, Gross, Net, Vat, 
	case when SendMessage=1 then @dt else null end as InvoiceSent,@dt,'sys'
	from #claim

	if @@rowcount>0
	begin
		--Create CMS Log Entry (requested by MW)
		exec ppd3.dbo.LogEntry @ClaimID=@claimid, @UserID='SYS', @Type='107', @Data=0, @Text='Fraud Screening Fee Added', @Status=@status, @WizardStatus=@wizardstatus
	end

if @@error != 0
	rollback tran
else
	commit tran

drop table #claim	
GO
