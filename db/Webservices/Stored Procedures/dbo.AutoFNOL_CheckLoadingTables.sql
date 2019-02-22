SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AutoFNOL_CheckLoadingTables]
@InstructionID int,
@IsError tinyint output,
@ErrorMsg varchar(1000) output
as
set nocount on
declare @ClaimOwner int, @insuranceclaimno varchar(50), @accountref varchar(50)

select @IsError=0,@ErrorMsg=''

select @insuranceclaimno=InsuranceClaimNo, @ClaimOwner=ClaimOwner, @accountref=isnull(accountref,'') 
from AUTOFNOL_Claims where messagelogid=@InstructionID

/*	duplicate check for Aviva messages 
	Rule 1: if claim already exists then update claim owner if its different
	Rule 2: if claim already exists and claim owner is the same then dont process
*/
if exists (select * from ppd3.dbo.claims c where InsuranceClaimNo=@insuranceclaimno)-- Duplicate claim exists?
 begin 
	if exists (select * from ppd3.dbo.claims c join ppd3.dbo.claimproperties cp on cp.ClaimID=c.ClaimID 
		where c.InsuranceClaimNo=@insuranceclaimno and cp.ClaimOwnership<>@ClaimOwner
	 ) 
	begin 
		update cp set cp.ClaimOwnership=@ClaimOwner
		from ppd3.dbo.ClaimProperties cp join ppd3.dbo.claims c on cp.ClaimID=c.ClaimID and c.InsuranceClaimNo=@insuranceclaimno
		
		update AUTOFNOL_MessageLog set [status]='Updated' where id=@InstructionID
		select @IsError=1,@ErrorMsg=''
		return
	end
	
	if (@accountref='')
	begin
		select @IsError=99,@ErrorMsg='No AccountRef Provided'
	end
else 
	 /* claim is a duplicate but claim owner hasn't changed so dont process' */
	 begin
		update AUTOFNOL_MessageLog set status='Duplicate' where id=@InstructionID
			
		select @IsError=2,@ErrorMsg=''
	 end 
 end 
GO
