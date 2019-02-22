SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CloseFraud]
@FIN varchar(10),
@UserID UserID,
@Decision varchar(50),
@SubCategory varchar(10),
@cancelCMS tinyint
as
set nocount on
declare @claim varchar(20),@Application varchar(50),@claimopen tinyint,@channel varchar(20)

select @claim=c.claimno,@Application=f.originatingsys, @channel=c.Channel
from fraud f join claims c on f.claimid=c.claimid
where f.fin=@fin

if @Application='PPD3'
	select @claimopen=case when [Status]<20 then 1 else 0 end from ppd3.dbo.claims where claimid=@claim

update Fraud set
	[status]=99,
	DateClosed=getdate(),
	AlteredDate=getdate(),
	AlteredBy=@UserID,
	ReasonClosed=@Decision,
	ReasonClosed_SubCategory=@SubCategory
where FIN=@FIN

exec ppd3.dbo.ICE_ActionFraudItems @claimid=@claim,@userid=@UserID

if(@cancelCMS=1 and @claimopen=1)
begin
	exec ppd3.dbo.CancelOrder	@claimID = @claim,	@userID = @userID,	@fee = 0,	@reason = 25
end


/* removed 31/07/2014 by Del after discusion with Nat H, see atom 49403
if ((@Decision in ('CAN','INSW','INSC','INSP','NFD','SBI','PPFR','PPFW','EFR') and @Application='PPD3')	or @channel='NUIBRAD' )
begin
	--clear flags in cms system
	exec ppd3.dbo.ICE_ActionFraudItems @claimid=@claim,@userid=@UserID
	if(@cancelCMS=1 and @claimopen=1)
	begin
		exec ppd3.dbo.CancelOrder	@claimID = @claim,	@userID = @userID,	@fee = 0,	@reason = 25
	end
end
else if (@Decision not in ('CAN','INSW','INSC','INSP','NFD','SBI','PPFR','PPFW') and @Application='FNOL')
begin
	--SW to define task
	select 1
end
*/



GO
