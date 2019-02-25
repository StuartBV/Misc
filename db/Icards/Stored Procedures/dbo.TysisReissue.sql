SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[TysisReissue]
@icardsid int,
@cardvalue money
as
set nocount on
set xact_abort on

declare 
@prefix varchar(3),
@nameoncard varchar(100),
@policyid int		
	
select @prefix=claimnoprefix 
from Card_Companies
where id=2

select distinct @nameoncard=nameoncard from policydetails where iCardsIDNoPrefix=@icardsid
 
begin tran

	insert into policies ( CompanyID, Status, SePSCode,
	                            InsuranceCoID, InsuranceClaimNo, InsurancePolicyNo,
	                            OrigOffice, ContactName, ContactPhone,
	                            LossAdjuster, LARef, LAOffice, IValRef,
	                            IncidentDate, wizardstage, CreateDate, CreatedBy)
	
	SELECT  2, Status, SePSCode, InsuranceCoID, InsuranceClaimNo, InsurancePolicyNo,
	        OrigOffice, ContactName, ContactPhone, LossAdjuster, LARef, LAOffice,
	        IValRef, IncidentDate, wizardstage, getdate(), 'sys.reissue' 
	FROM policies where icardsid=@icardsid
	
	
	set @policyid=SCOPE_IDENTITY()
	--select @policyid
	
	
	insert into customers (icardsid,companyid,title,firstname,lastname,address1,address2,
					town,county,postcode,phone,createdate,createdby,DateOfBirth) 
	select @policyid,2,title,firstname,lastname,address1,address2,
					town,county,postcode,phone,getdate(),'sys.reissue',DateOfBirth
	from customers where iCardsID=@icardsid

	update policies set customerid=SCOPE_IDENTITY() 
	where icardsid = @policyid

	insert into cards (customerid,nameoncard,cardtype,createdate,createdby) 
	values (SCOPE_IDENTITY(),@nameoncard,6,getdate(),'sys.reissue')

	insert into transactions (cardid,cardvalue,type,createdate,createdby,origvalue,incentive,incentiverate,AuthRequirement,Status,InvoicedDate,InvoiceBatchNo) 
	values (SCOPE_IDENTITY(),@cardvalue,'M',getdate(),'sys.reissue',@cardvalue,1,0,0,1,getdate(),'reissue')
	

COMMIT



GO
