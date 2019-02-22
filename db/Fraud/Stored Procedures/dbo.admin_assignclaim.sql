SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[admin_assignclaim] 
@claimid varchar(20),
@userid UserID,
@claimhandler varchar(20)
as 
declare @nt varchar(500), @claim int


set transaction isolation level read uncommitted

update f set
	f.ClaimHandler=@claimhandler,
	f.AlteredBy=@userid,
	f.AlteredDate=getdate()
from fraud f join claims c on f.ClaimID = c.ClaimID
where c.claimno=@claimid

select @claim=claimid from claims c where c.claimno=@claimid

select @nt='claim re-assigned to '+e.fname+' '+e.sname
from ppd3.dbo.logon l join ppd3.dbo.employees e  on e.id=l.userfk
where l.UserID=@claimhandler

exec AddNoteToClaim @ClaimId=@claim,@note=@nt,@userid=@UserID,@notereason=0

GO
