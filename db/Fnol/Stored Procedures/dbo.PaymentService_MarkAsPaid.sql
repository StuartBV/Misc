SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[PaymentService_MarkAsPaid]
@guid varchar(100)
as

set nocount on 

update dbo.FNOL_ClaimPayments
set [status]='PAID',
DatePaid=getdate(),
AlteredBy='PaymentService',
AlteredDate=getdate()
where PaymentServiceGuid=@guid
GO
