SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PaymentServiceUpdate]
@guid varchar(38),
@success bit
as
set nocount on
declare @dt datetime=getdate(), @claimid int

update FNOL_ClaimPayments set
	[status]=case when @success=1 then 'PAID' else 'DEC' end,
	DateAuthorised=case when @success=1 then @dt else DateAuthorised end,
	DateDeclined=case when @success=0 then @dt else null end,
	DatePaid=case when @success=0 then null else DatePaid end,
	AlteredBy='PaymentService', AlteredDate=@dt
where PaymentServiceGuid=@guid

if @success=0
begin
	select @claimid=claimid
	from fnol_claimpayments 
	where PaymentServiceGuid=@guid

	update Fnol_Claims set [status]='FPAY' where claimid=@claimid

	exec AddNoteToClaim @ClaimID=@claimid, @note='BACS Settlement Payment Failed', @userid='SYS'
end
GO
