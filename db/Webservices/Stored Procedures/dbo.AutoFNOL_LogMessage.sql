SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[AutoFNOL_LogMessage]
@Msg text,
@InsuranceClaimNo varchar(50)
as
declare 
@messageid int

set nocount on

insert into AutoFNOL_MessageLog (createdate,original_message,insuranceclaimno,status) 
VALUES (getdate(),@msg,@InsuranceClaimNo,'Received')

select @messageid=SCOPE_IDENTITY() 

select @messageid

GO
