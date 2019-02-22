SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[PaymentService_FailedPayment]
@guid varchar(100),
@reason varchar(500)
as
declare
@claimid int

set nocount on 

update dbo.FNOL_ClaimPayments
set [status]='DEC',
DatePaid=null,
DateDeclined=getdate(),
AlteredBy='PaymentService',
AlteredDate=getdate()
where PaymentServiceGuid=@guid

select @claimid=claimid
from fnol_claimpayments 
where PaymentServiceGuid=@guid

update dbo.FNOL_Claims 
set status='FPAY'
where claimid=@claimid

exec dbo.AddNoteToClaim 
	@ClaimID = @claimid, -- int
    @note = @reason, -- text
    @userid = 'SYS'
GO
