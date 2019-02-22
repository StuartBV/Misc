SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PaymentService_SaveGuid]
@guid varchar(100),
@id int
as

set nocount on 

update dbo.FNOL_ClaimPayments
set PaymentServiceGuid=@guid,
[status]='REC',
ChequeNo='BACS',
AlteredBy='PaymentService',
AlteredDate=getdate()
where id=@id

GO
