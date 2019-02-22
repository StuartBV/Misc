SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AUTOFNOL_PushToPPD3]
@InstructionId int
as
--UTC--
set nocount on
set transaction isolation level read uncommitted

declare @errormessage varchar(255), @errorCode int

-- Push's data from the webservIces excms_* staging tables to PPD3
declare @claimid int, @custid int,@offIceid int,@userid varchar(50),@order tinyint,@channel varchar(50),@accountref varchar(50),@insurancePolicyNo varchar(50),@insurancoid int,
	@insuranceclaimno varchar(50),@claimreceiveddate varchar(50),@claimreceivedtime varchar(50),@incidentdate varchar(50),@excess smallmoney,@causeofclaim varchar(50),
	@causeofclaimnotes varchar(1000),@PolicyInceptionDate datetime,@InstructionType varchar(100),@SFindicator int,@ClaimOwner int,@OtherLimit smallmoney,@HRlimit smallmoney,
	@SAlimit smallmoney,@EmergencyClaim tinyint,

-- Customer Variables
	@title varchar(50),@fname varchar(50),@lname varchar(50),@hphone varchar(50),@wphone varchar(50),@mphone varchar(50),	@email varchar(200),@address1 varchar(50),
	@address2 varchar(50),@address3 varchar(50),@town varchar(50),@county varchar(50),@country varchar(50),@postcode varchar(10),@ClaimDetailedInfo varchar(8000),
	@SpecialInstuctions varchar(4000),@ClaimInvoIceLocation varchar(20),@AdditionalPolicyHolderTitle varchar(50),@AdditionalPolicyHolderForename varchar(50),
	@AdditionalPolicyHolderSurname varchar(50),@PreferredContactMethod smallint,@Workstream varchar(50),

	@contactnotes varchar(1000),@superfmt varchar(10), @claimitemid int,@oiid int,@lastoiid int,@vno int,@itemstatus int,@notetext varchar(3000),@logtext varchar(1000),
	@PolicyApplicableLimits varchar(255),@PolicySpecifiedItemsAndSI varchar(255),@PolicySingleArticleLimit smallmoney,@PolicyOtherDetails varchar(255),@PolicyCover varchar(255),
	@LossAdjuster int,@PolicyHolderContactNameAndRole varchar(255),@PolicyHolderOtherDetails varchar(255),@DuplicateFlag bit,@OriginatingOffIce varchar(50),@BusinessName varchar(500),		
	@crlf char(2)=char(10)+char(13), @claimjob int,@ordertype char(1), @claimstep int=1,@wizardstatus smallint=1,@VAT varchar(1)='N', @dt datetime=getdate(), @txt VARCHAR(500)

select        
	@offIceid=10,
	@userid='sys.AutoFnol',
	@insurancepolicyno=left(c.InsurancePolicyNo,50),
	@insuranceclaimno=left(c.InsuranceClaimNo,50),
	@claimreceiveddate=convert(char(10),c.createdate,103),
	@claimreceivedtime=convert(char(5),c.CreateDate,114),
	@incidentdate=convert(char(10),c.IncidentDate,103),
	@excess=isnull(c.Excess,0),
	@causeofclaim=left(c.CauseofClaim,50),
	@causeofclaimnotes=isnull(left(c.CauseofClaimNotes,1000),''),
	@contactnotes='',  
	@ClaimOwner=c.ClaimOwner,
	@SFindicator=c.SFindicator,
	@OtherLimit=case when c.OtherLimit>214000 then 214000 else c.OtherLimit end,
	@SAlimit=case when c.SAlimit>214000 then 214000 else c.SAlimit end,
	@HRlimit=case when c.HRlimit>214000 then 214000 else c.HRlimit end,
	@PolicyInceptionDate=c.PolicyInceptionDate,
	@title=isnull(left(cu.Title,50),''),
	@fname=isnull(left(cu.Fname,50),''),
	@lname=isnull(left(cu.Lname,50),''),
	@hphone=isnull(left(cu.Hphone,50),''),
	@wphone=isnull(left(cu.wphone,50),''),
	@mphone=isnull(left(cu.mphone,50),''),
	@email=isnull(left(cu.Email,200),''),
	@BusinessName=isnull(cu.businessname,''),
	@AdditionalPolicyHolderTitle=isnull(left(c.AdditionalCustomerTitle,50),''),
	@AdditionalPolicyHolderForename=isnull(left(c.AdditionalCustomerFname,50),''),
	@AdditionalPolicyHolderSurname=isnull(left(c.AdditionalCustomerLname,50),''),		
	@address1=isnull(left(cua.Address1,50),''),
	@address2=isnull(left(cua.Address2,50),''),
	@address3=isnull(left(cua.Address3,50),''),
	@town=isnull(left(cua.town,50),''),
	@county=isnull(left(cua.County,50),''),
	@country=isnull(left(cua.Country,50),''),
	@postcode=isnull(left(cua.Postcode,10),''),
	@ClaimDetailedInfo=isnull(left(c.CauseofClaimNotes,1000),''),
	@InstructionType=c.Claimtype,
	@SpecialInstuctions=left(c.specialInstructions,4000),
	@LossAdjuster=pla.id,
	@PreferredContactMethod=cu.PreferredContactMethod,
	@Emergencyclaim=c.EmergencyClaim
from AutoFnol_Claims c 
join AutoFnol_Customers cu on cu.custid=c.custid
join AutoFnol_Addresses cua on cu.custid=cua.custid
left join AutoFnol_LossAdjusters la on la.MessageID=c.MessageID
left join ppd3.dbo.LossAdjusters pla on la.name=pla.name
where c.messagelogid=@InstructionId

select @accountref=c.AccountRef,@insurancoid=b.clientid,@OriginatingOffIce=b.offIce,@channel=coalesce(c.channel,i.InscoChannel)
from AutoFnol_Claims c join ppd3.dbo.SePSBranches b on c.AccountRef=b.AccountRef
join ppd3.dbo.InsuranceCos i on b.clientid=i.ID
where c.messagelogid=@InstructionId

if @accountref is null
 begin
	update AutoFnol_MessageLog set
		cms_claimid=@claimid,
		[status]='ERROR'
	where id=@InstructionId

-- Added the below to email us when this happens again on 13/09/2017 after looking into issues reported to Gary by Aviva. - LI
-- it will be that the ProductName within the original XML is not included within AUTOFNOL_Lookup

	SET @txt = 
	'Please find details within: SELECT * FROM Webservices.dbo.AutoFnol_Claims WHERE MessageLogID = ' + CAST(@instructionID AS VARCHAR) + ' to report this to Gary / the client.'

	EXEC SendMail @Recipient = 'IT.Support@bevalued.co.uk', 
	@SenderEmail = 'noreply@bevalued.co.uk', 
	@SenderName = 'AUTOFNOL_PushToPPD3', 
	@Subject = 'Error with instruction received: Cannot map AccountRef',  
	@Body = @txt, 
	@attach = '',   
	@Bcc = ''        

  end 

else
 begin 


	-- set to quote or order
	if @InstructionType='O'
	begin
		select @order=1,@claimjob=1,@ordertype='O' -- 1=Order
	end
	else
	begin
		select @order=0,@claimjob=3,@ordertype='Q' -- 0=Quote
	end

	set transaction isolation level read committed
	begin tran

		-- Create the new claim
		exec ppd3.dbo.claimCreateNew @userid=@userid, @status=@order, @channel=@channel, @claimidout=@claimid output
		if (@@error!=0)
		begin
			set @errormessage='claimCreateNew error'
			goto error_handler
		end

		-- populate the new claim with information
		update ppd3.dbo.claims set
			Accountref=@accountref,
			offIceid=@offIceid,
			InsuranceCoID=@insurancoid, 
			InsurancePolicyNo=@insurancepolicyno,
			InsuranceClaimNo=@insuranceclaimno,
			OriginatingOffIce=@originatingOffIce,
			CauseOfClaim=@causeofclaim,
			CauseofClaimNotes=@causeofclaimnotes,
			sepscode=case when @accountref='' then sepscode else @accountref end,
			wizardstatus=@wizardstatus,
			CrimeRefNumber='',
			allowedqty=0,
			allowedrrp=0,
			otherlimit=@OtherLimit,
			delegated=@order,
			SALimit=@SAlimit, 
			HRLimit=@HRlimit,
			LossAdjusterID=@LossAdjuster,
			[status]=@order, 
			ClaimReceivedDateUTC=case when @ClaimReceivedDate='' then null else @claimReceivedDate + ' ' + @ClaimReceivedTime end,
			IncidentdateUTC=case when @Incidentdate='' then null else @IncidentDate end,
			commercial=case when @businessname='' then 0 else 1 end,
			excess=@excess,
			alteredby=@userid, 
			altereddate=@dt 
		where claimID=@claimID

		if (@@error!=0)
		begin
			set @errormessage='claimpopulate broken'
			goto error_handler
		end

		--update claimproperties table with cash settlement % from Insurance Co
		update cp set 
			cp.cashsettleperc=ic.cashsettleperc,
			cp.allowcashsettle=ic.allowcashsettle,
			cp.alteredby=@userid,
			cp.altereddate=@dt,
			PolicyInceptionDate=@PolicyInceptionDate,
			ClaimOwnership=@ClaimOwner,
			FraudIndicator=@SFindicator,
			EmergencyClaim=@EmergencyClaim,
		cp.claimsource=1
		from ppd3.dbo.claimproperties cp join ppd3.dbo.claims c on cp.claimid=c.claimid
		join ppd3.dbo.insurancecos ic on c.insurancecoid=ic.id
		where cp.claimid=@claimid 

		if (@@error!=0)
		begin
			set @errormessage='claimPropertiesUpdate broken'
			goto error_handler
		end

		-- Create a new customer
		exec ppd3.dbo.CustomerCreateNew @claimid=@claimid, @userid=@userid, @custidout=@custid output

		if (@@error!=0)
		begin
			set @errormessage='CustomerCreateNew broken'
			goto error_handler
		end

		-- Update customer details
		update cu set
			title=@title,
			fname=@fname,
			lname=@lname,
			secondTitle=@AdditionalPolicyHolderTitle, 
			secondFname=@AdditionalPolicyHolderForename, 
			secondLname=@AdditionalPolicyHolderSurname,
			hphone=@hphone,
			wphone=@wphone,
			mphone=@mphone,
			fax='',
			email=@email,
			businessname=@businessname,
			vatregistered=case when @businessname!='' and @vat='Y' then 1 else 0 end,
			address1=case when @address1!='' then @address1 else address1 end,
			address2=@address2,
			town=case when @town!='' then @town else town end,
			county=case when @county!='' then @county else county end,
			postcode=case when @postcode!='' then @postcode else postcode end,
			otherinfo=@contactnotes,
			PreferredContactMethod=isnull(@PreferredContactMethod,0),
			altereddate=@dt,
			alteredby=@userid
		from ppd3.dbo.claims c join ppd3.dbo.customers cu  on cu.id=c.CustID
		where c.claimid=@claimid

		if (@@error!=0)
		begin
			set @errormessage='update ppd3.dbo.customers broken'
			goto error_handler
		end

		-- create claim products
		insert into ppd3.dbo.Ice_ClaimProducts (claimid,catid,make,model,description,age,value,Instruction,limit,specificvalue,createdby,createdate) 
		select @claimid,isnull(cp.catid,0) as CatID,isnull(cp.make,''),isnull(cp.model,''),isnull(cp.description,''),0,0,isnull(cp.Instruction,0),0,0,isnull(cp.createdby,@userid),cp.createdate 
		from AutoFnol_ClaimProducts cp join AutoFnol_Claims c  on cp.MessageID=c.MessageID
		where c.MessageLogID=@instructionId

		if (@@error!=0)	
		begin	
			set @errormessage='Ice_claimProducts broken'
			goto error_handler
		end

		-- update product categories, allowed qty, allowed rrp etc
		exec ppd3.dbo.Ice_UpdateClaimCategories @claimid=@claimid, @userid=@userid

		if (@@error!=0)	
		begin	
			set @errormessage='Ice_UpdateClaimCategories broken'
			goto error_handler
		end

		-- set status of claim
		exec ppd3.dbo.Ice_SetNextStep	@claimid=@claimid, @userid=@userid

		if (@@error!=0)	
		begin	
			set @errormessage='Ice_SetNextStep broken with params claimid=' + cast(@claimid as varchar(12)) + ', @userid='+@userid + ' Error= ' + cast(@@error as nvarchar(8))
			goto error_handler
		end

		exec ppd3.dbo.Ice_SetClaimJob @claimid, @claimjob

		if (@@error!=0)	
		begin	
			set @errormessage='Ice_SetClaimJob broken with params claimid=' + cast(@claimid as varchar(12)) + ', '+cast(@claimjob as varchar) + ' Error= ' + cast(@@error as nvarchar(8))
			goto error_handler
		end

		exec ppd3.dbo.Ice_SetClaimStep @claimid, @claimstep

		if (@@error!=0)
		begin
			set @errormessage='Ice_SetClaimStep broken'
			goto error_handler
		end

		-- Create order row
		exec ppd3.dbo.ClaimCreateNewOrder @status=@ordertype, @claimid=@claimid, @empid=@userid

		if (@@error!=0)
		begin
			set @errormessage='exec ppd3.dbo.ClaimCreateNewOrder broken'
			goto error_handler
		end

		-- Create a log entry on the claim
		set @logtext='Claim created via Auto FNOL'
		exec ppd3.dbo.LogEntry @claimid=@claimid, @userid=@userid, @type='700', @data=@instructionId, @text=@logtext
		if (@@error!=0)
		begin
			set @errormessage='exec ppd3.dbo.LogEntry broken'
			goto error_handler
		end

		-- Create a standard note on the claim
		set @Notetext='Auto Note via Auto FNOL:
		Claim Incident Details: Incident Date ' + @incidentdate + '
		' + @ClaimDetailedInfo
		exec ppd3.dbo.NoteCreate @claimid=@claimid, @note=@notetext, @userid=@userid, @notetype=220, @notereason=0
		if (@@error!=0)
		begin
			set @errormessage='exec ppd3.dbo.NoteCreate broken'
			goto error_handler
		end

		-- Create a Special Instructions note on the claim
		if (@SpecialInstuctions!='')
		begin
			set @Notetext='Auto Note via Auto FNOL - Special Instructions:
			Instruction: ' +  @SpecialInstuctions
			exec ppd3.dbo.NoteCreate @claimid=@claimid, @note=@notetext, @userid=@userid, @notetype=220, @notereason=0
			if (@@error!=0)
			begin
				set @errormessage='exec ppd3.dbo.NoteCreate broken'
				goto error_handler
			end
		end

		-- 2.4 Insert Notes for the claim.
		insert into ppd3.dbo.Notes (ClaimID,Note,CreateDate,CreatedBy,NoteType,NoteReason, NoteCreateDate) 
		select @claimid,n.notetext,@dt,@userid,220,0, timezone.dbo.PPGetDate(1610)
		from AutoFnol_Notes n join AutoFnol_Claims c  on n.MessageID=c.MessageID
		where c.MessageLogID=@InstructionId
		if (@@error!=0)
		begin
			set @errormessage='insert into ppd3.dbo.Notes broken'
			goto error_handler
		end

		--exec ppd3.dbo.NA_DomainEventHandler @claimid=@claimid, @Iceitemid=null, @userid=@userid, @devent=90, @schedulefrom=null
		--if (@@error!=0)
		--begin
		--	set @errormessage='Diary Management Handler broken'
		--	goto error_handler
		--end

		exec ppd3.dbo.Claims_Search_Update @claimid=@claimid,@userid=@userid
		if (@@error!=0)
		begin
			set @errormessage='Claims Search Update Proc broken'
			goto error_handler
		end

		update AutoFnol_MessageLog set
			cms_claimid=@claimid,
			[status]='Uploaded',
			pushedtoppd3=@dt
		where id=@InstructionId

		-- 2.5 insert into claimtypes
		insert into ppd3.dbo.ClaimTypes (ClaimId, ClaimType, CreatedBy)
		values	(@claimid, 1, 'sys')

	commit
 end

return 

error_handler:

exec logging.dbo.SaveLog '','ERROR','AutoFnol_PushToPPD3','Fatal Error occured in pushToPPD3','','AutoFnol WebServIce'
raiserror(@errormessage,18,1)
rollback
update AutoFnol_MessageLog set [status]='Upload Error' where id=@InstructionId



GO
