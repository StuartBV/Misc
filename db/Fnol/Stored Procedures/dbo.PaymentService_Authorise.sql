SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PaymentService_Authorise]
@id int
as

set nocount on 

update dbo.FNOL_ClaimPayments
set [status]='AUTH',
DateAuthorised=getdate(),
AlteredBy='PaymentService',
AlteredDate=getdate()
where id=@id

GO
