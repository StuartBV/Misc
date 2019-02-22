SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PassFNOLtoFraud]
@claimID int,
@UserID UserID
as

set transaction isolation level read uncommitted

declare @fin varchar(10),@num varchar(6),@prefix varchar(5),@amount_claimed money,@initial_reserve money,@excess money,@ID int, @dt datetime=getdate()

set @UserID=replace(@UserID,'%2E','.')

if not exists (select * from claims c1 join fnol.dbo.fnol_claims c2 on c1.ClaimNo=c2.ClientRefNo and c2.claimid=@claimID)
begin
	--get next FIN number from syslookup
	select @num=code,@prefix=ExtraCode from sysLookup where TableName='FraudNumber'
	update sysLookup set Code=cast(cast(code as int)+1 as varchar) where TableName='FraudNumber'

	set @fin=@prefix+@num

	begin tran
		--copy relevant data from customers table
		insert into Customers (Title,Fname,Lname,Address1,Address2,Town,County,Postcode,Country,
		Hphone,Wphone,Mphone,email,CreateDate,CreatedBy,AlteredDate,AlteredBy)
		select Title,Fname,sname,Address1,Address2,city,County,Postcode,Country,
		Hphone,Wphone,Mphone,email,CreatedDate,CreatedBy,AlteredDate,AlteredBy
		from fnol.dbo.fnol_claims cl
		where cl.claimid=@claimID

		set @ID=scope_identity()

		--copy relevant data from claims table
		insert into claims (ClaimNo,OriginClaimID,QuoteCreatedDate,QuoteCreatedBy,CustID,InsurancePolicyNo,causeofClaim,CompletedDate,
			CreateDate,CreatedBy,CrimeRefNumber,IncidentDate,ClaimReceivedDate,OtherLimit,causeofclaimnotes,channel) 
		select c.ClientRefNo,@claimID,c.CreatedDate,c.CreatedBy,@ID,p.PolicyNo,c.Cause,c.DateFinalised,@dt,@userId,
		c.CrimeRef,c.IncidentDate,c.CreatedDate,c.Final_Cost,c.[description],p.Client
		from fnol.dbo.FNOL_Claims c join fnol.dbo.FNOL_Policy p on c.PolicyID=p.ID 
		where c.claimid=@claimID

		set @ID=scope_identity()

		--create new fraud record
		insert into Fraud (FIN,ClaimID,CurrentTier,[status],originatingsys,createdate,createdby)
		values (@fin,@ID,2,1,'FNOL',@dt,@UserID ) 

		--copy relevant data from claimproperties table
		insert into ClaimProperties (ClaimID,CreateDate,CreatedBy,PolicyInceptionDate,Amount_Claimed,Initial_Reserve)
		select @ID,@dt,@UserID,p.InceptionDate,c.Estimate,c.Reserve
		from fnol.dbo.FNOL_Claims c join fnol.dbo.FNOL_Policy p on c.policyid=p.id
		where c.claimid=@claimID

		--copy relevant data about the products on the claim
		insert into ClaimProducts (claimid,catid,model,[description],value,createdby,createdate)
		select @ID,AssetNo,MakeModel,[description],ItemValue,@UserID,@dt
		from fnol.dbo.FNOL_ClaimItems
		where claimid=@claimID

		--create log entry
		exec LogEvent @FIN=@fin, @UserID=@UserID, @Tier=2, @Status=1, @Action=1
	commit tran

end
GO
