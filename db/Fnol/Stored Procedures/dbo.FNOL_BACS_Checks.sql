SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[FNOL_BACS_Checks] as

set nocount on 
 
/* code removed by DelF to see if we still have any issues */
 
--update cp set cp.[status]='AUTH'
--from dbo.FNOL_ClaimPayments cp 
--join PaymentService.dbo.Payments p  on cp.PaymentServiceguid = p.[guid]
--where (cp.[status]<>'AUTH' or cp.DateAuthorised is null)
--and p.DatePaid is null and p.[status]=2

--update p set p.[status]=2
--from dbo.FNOL_ClaimPayments cp 
--join PaymentService.dbo.Payments p  on cp.PaymentServiceguid = p.[guid]
--where (cp.[status]='AUTH' and cp.DateAuthorised is not null)
--and p.DatePaid is null and p.[status]=1

--update p set p.[status]=99
--from PaymentService.dbo.Payments p 
--where p.[status]=2 and not exists(select * from FNOL_ClaimPayments cp where claimid=p.OurRef and PaymentServiceguid=p.[guid])

select 'BACS Records have been checked and/or corrected.' [message]

GO
