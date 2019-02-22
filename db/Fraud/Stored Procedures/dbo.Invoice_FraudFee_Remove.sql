SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_FraudFee_Remove]
@claimid int
as
set nocount on
set xact_abort on

declare @now datetime=getdate(), @feetype tinyint, @wizardstatus smallint, @status smallint
select @feetype=sys.flags from fraud.dbo.sysLookup sys where sys.tablename='FeeTypes' and sys.code='FraudScreening'
select @status=c.[status], @wizardstatus=c.WizardStatus from ppd3.dbo.claims c where c.claimid=@claimid

-- Remove any fraud fee where applicable.
if exists(select * from ppd3.dbo.claims c
	join ppd3.dbo.channels ch on ch.channel=c.channel and ch.ChargeFraudScreeningFee=1 and ch.[FraudScreeningInvoiceType]=0 -- only where we invoice via bordereaux
	where c.claimid=@claimid
)
begin
	begin tran
		delete from f
		from Fees f join ppd3.dbo.claims c on f.claimid=c.claimid and c.claimid=@claimid
		join claims fc on fc.OriginClaimID=c.claimid
		join fraud fd on fd.ClaimID=fc.ClaimID and fd.OriginatingSys='PPD3' 
		where f.invoicesent is null -- Not where invoice already sent.
		and f.feetype=@feetype

		if @@rowcount>0
		begin
			exec ppd3.dbo.LogEntry @ClaimID=@claimid, @UserID='SYS', @Type='107', @Data=0, @Text='Fraud Screening Fee Removed', @Status=@status, @WizardStatus=@wizardstatus
		end		
		else
		begin
			exec ppd3.dbo.LogEntry @ClaimID=@claimid, @UserID='SYS', @Type='107', @Data=0, @Text='Fraud Screening Fee Remove ATTEMPTED but failed', @Status=@status, @WizardStatus=@wizardstatus
		end	

	if @@error <> 0
		rollback tran
	else
		commit tran
end
GO
