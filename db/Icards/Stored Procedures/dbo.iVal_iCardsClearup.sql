SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iVal_iCardsClearup]
@claimid varchar(50),
@sepscode varchar(50),
@title varchar(50),
@firstname varchar(50),
@lastname varchar(50),
@address1 varchar(50),
@address2 varchar(50),
@city varchar(50),
@county varchar(50),
@postcode varchar(50),
@phone varchar(50),
@cardtype int,
@cardvalue money,
@cardoption varchar(50),
@nameoncard varchar(50),
@insurancecoid int,
@insurancepolicyno varchar(50),
@insuranceclaimno varchar(50),
@origoffice varchar(50),
@incidentdate varchar(50),
@incentivise int,
@cardid int,
@origvalue money,
@iCardsId varchar(50),
@incentval money,
@lolrrp varchar(10),
@dupstage int,
@typ int,
@userid UserID,
@wizardstage int=4,
@suppliers varchar(200)='', -- New supplier comma separated list with values e.g. 6261:29.99,4918:12.52
@dob varchar(10)=null,
@companyid int=2
as
set nocount on
--UTC--

/*
<SP>
	<Name>iVal_iCardsClearup</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060512</CreateDate>
	<Referenced>
		<asp>iCardsProcessFrame.asp</asp>
	</Referenced>
	<Overview>Called from iCardsProcessFrame.asp to create new ival card on iCards system via the clearup process on the intranet</Overview>
	<Changes>		
		<Change>
			<User>DerekF</User>
			<Date>20060613</Date>
			<Comment>amended so that ival clearups can be added to existing cards</Comment>
		</Change>
		<Change>
			<User>markha</User>
			<Date>20091230</Date>
			<Comment>amended so that ival clearups can have supplier marked as part of settlement</Comment>
		</Change>
		<Change>
			<User>DerekF</User>
			<Date>20110223</Date>
			<Comment>amended for FIS usage, ie storing of DOB and companyid</Comment>
		</Change>
	</Changes>
</SP>
*/

declare @policyid int,@prefix varchar(3),@ValueType varchar(1),@logtext varchar(100),@notetext varchar(1000),@ID varchar(100),@customerid int,@excess money,
	@transactionid int,@supplierslist varchar(500),@crlf char(1)=char(13), @icardsfkid int,@authrequirement int, 
	@charpos int, @idpair varchar(200),@supplierid int, @supplierrrpvalue smallmoney, @dt datetime=getdate()

declare @suppliersT table(Uid int identity(1,1) primary key, supplierid int, rrpvalue smallmoney)

set @charpos=charindex(',',@suppliers) 	-- Get position of first pair of suppliers/rrp values
while @charpos>0			-- Whilst still more to process
begin
	set @idpair=left(@suppliers,@charpos-1) --get first set
	set @supplierid=left(@idpair,charindex(':',@idpair)-1)
	set @supplierrrpvalue=cast(right(@idpair,len(@idpair)-charindex(':',@idpair)) as smallmoney)
	set @suppliers=right(@suppliers,len(@suppliers)-@charpos) -- if any more products, sort for next loop
	set @charpos=charindex(',',@suppliers) 
	insert into @suppliersT select @supplierid,@supplierrrpvalue
end

select @supplierslist=coalesce(@supplierslist + @crlf,'') + ltrim(rtrim(isnull(d.name,'') + ': '+ ppd3.dbo.currencysymbol(@claimid) + isnull(cast(s.rrpvalue as varchar),'')))
from @suppliersT s join ppd3.dbo.Distributor d on d.id=s.supplierid

select @prefix=claimnoprefix 
from Card_Companies
where id=@companyid

-- establish what excess is on the claim
select @excess=case when excesspaidUTC is null then coalesce(excesstocollect,excess,0) end 
from ppd3.dbo.claims 
where claimid=@claimid

--we are creating a new policy and card
if @dupstage=0 and not exists (select * from dbo.PolicyDetails where IValRef=@claimid and [type]='m' and CardValue=@cardvalue and companyID=@companyid) --added to prevent duplicates
 begin
	set @ValueType='M'

	begin tran
		insert into policies (companyid,insurancecoid,insurancepolicyno,insuranceclaimno,origoffice,ivalref,incidentdate,createdate,createdby,wizardstage,sepscode) 
		values (@companyid,@insurancecoid,@insurancepolicyno,@insuranceclaimno,@origoffice,@claimid,@incidentdate,@dt,@userid,@wizardstage,@sepscode)

		set @policyid=scope_identity()

		insert into customers (icardsid,companyid,title,firstname,lastname,address1,address2,town,county,postcode,phone,createdate,createdby,DateOfBirth) 
		values (@policyid,@companyid, 
			case when len(@title)>4 then 
				case when charindex(char(32),@title)>4 or charindex(char(32),@title)=0 then 
					left(@title,4) 
				else 
					left(@title,charindex(char(32),@title)) 
				end
			else @title end,
			case when len(isnull(@firstname,''))=0 then left(@nameoncard,1) else @firstname end,
			@lastname,@address1,@address2,@city,@county,@postcode,@phone,@dt,@userid,@dob)

		update policies set customerid=scope_identity() 
		where icardsid=@policyid

		insert into cards (customerid,nameoncard,cardtype,createdate,createdby) 
		values (scope_identity(),@nameoncard,@cardtype,@dt,@userid)

		insert into transactions (cardid,cardvalue,type,createdate,createdby,origvalue,incentive,incentiverate) 
		values (scope_identity(),@cardvalue,@ValueType,@dt,@userid,@origvalue,@incentivise,@incentval)

		set @transactionid=scope_identity()

		-- Insert Transaction suppliers if necessary
		insert into transactionsuppliers(TransactionID,SupplierID, RRP)
		select @transactionid,supplierid, rrpvalue
		from @suppliersT

		--Update Auth Requirement on the transaction
		set @authrequirement=dbo.AuthRequirement(@postcode,@transactionid,@cardvalue)

		update transactions set
			authrequirement=@authrequirement,
			[status]=case when AuthRequirement=0 and @companyid=2 then 1 else 0 end
		where id=@transactionid and [status]=0 and InvoiceBatchNo is null and InvoicedDate is null

		-- Update Orderitems set action to iVal Options Card
		update ppd3.dbo.OrderItems set 
			[action]=@typ+100,
			[status]='SENT',
			stockstatus=10,
			datesentUTC=@dt 
		where claimid=@claimid 
		and [type]='O' and [action]=@typ and [action] between 8 and 11

		-- update claims to set excess paid if required
		if(@excess>0)
		begin
			update ppd3.dbo.claims set excesspaidUTC=dbo.SN_TimeZone_ConvertLegacyDateTimeToPPDate(@dt),excesspaymethod='External_Options' 
			where claimid=@claimid
		end

		-- Insert SP for CPL. SD/MW agreed.
		if exists (select * from ppd3.dbo.Claims c join ppd3.dbo.SupplierConfig sc on sc.channel=c.channel and sc.supplierid=6500
				and (excesspaidUTC is not null and sc.SupplierCollectsXS=1)
			where c.claimid=@claimid and excess>0
		)
		begin
			set @icardsfkid=cast(right(@iCardsId,6) as int)
			exec ppd3.dbo.SupplierPayments_Log @claimid=@claimid,@supplierid=6500,@fkid=@icardsfkid, @sendmethod='NV',@suppliercollectsxs=1,@excess=@excess, @userid='SP_iVal_iCardsClearup',@validatedsupplier=0
		end

		set @logtext='iVal clearup process created Options card for ' + @lolrrp 
			+ ' value of £ ' +cast(@cardvalue as varchar) 
			+ ' which was incentivised by ' + cast(@incentval as varchar) + '%'
		set @ID=@prefix+cast(@policyid as varchar)
		exec LogEntry @iCardsid=@ID, @userid=@userid, @Data=@claimid, @type=1, @text=@logtext

		set @notetext='iVal clearup process created Options card for ' + @lolrrp 
			+ ' value of £ ' +cast(@cardvalue as varchar) 
			+ ' which was incentivised by ' + cast(@incentval as varchar) + '%' 
			+ case when isnull(@supplierslist,'')!='' then 
				' which included the following supplier breakdown: ' +@supplierslist else '' end
		exec ppd3.dbo.NoteCreate @ClaimID=@claimid, @note=@notetext, @userid=@userid, @notetype=0
	commit transaction
end

--we are going to add value to an existing policy and card
if(@dupstage=1)
 begin
	begin tran
		set @ValueType='B'
		insert into transactions (cardid,cardvalue,[type],createdate,createdby,origvalue,incentive,incentiverate) 
		values (@cardid,@cardvalue,@ValueType,@dt,@userid,@origvalue,@incentivise,@incentval)

		set @transactionid=scope_identity()

		-- Insert Transaction suppliers if necessary
		insert into transactionsuppliers(TransactionID,SupplierID, RRP)
		select @transactionid,supplierid, rrpvalue
		from @suppliersT

		--Update Auth Requirement on the transaction
		set @authrequirement=dbo.AuthRequirement(@postcode,@transactionid,@cardvalue)

		update transactions set 
			authrequirement=@authrequirement,
			[status]=case when AuthRequirement=0 and @companyid=2 then 1 else 0 end
		where id=@transactionid and [status]=0 and InvoiceBatchNo is null and InvoicedDate is null

		--update policy with ival ref
		update policies set ivalref=@claimid where icardsid=right(@iCardsId,6)

		-- Update Orderitems set action to iVal Options Card
		update ppd3.dbo.OrderItems set
			[action]=@typ+100,
			[status]='SENT',stockstatus=10,
			datesentUTC=dbo.SN_TimeZone_ConvertLegacyDateTimeToPPDate(@dt)
		where claimid=@claimid and [type]='O' and [action]=@typ and [action] between 8 and 11

		-- update claims to set excess paid if required
		if(@excess>0)
		begin
			update ppd3.dbo.claims set
				excesspaidUTC=dbo.SN_TimeZone_ConvertLegacyDateTimeToPPDate(@dt),
				excesspaymethod='External_Options'
			where claimid=@claimid
		end

		-- Insert SP for CPL. SD/MW agreed.
		if exists (select * from ppd3.dbo.Claims c join ppd3.dbo.SupplierConfig sc on sc.channel=c.channel and sc.supplierid=6500
				and (excesspaidUTC is not null and sc.SupplierCollectsXS=1)
			where c.claimid=@claimid and excess>0
		)
		begin
			set @icardsfkid=cast(right(@iCardsId,6) as int)
			exec ppd3.dbo.SupplierPayments_Log @claimid=@claimid,@supplierid=6500,@fkid=@icardsfkid, @sendmethod='NV',@suppliercollectsxs=1,@excess=@excess,@userid='SP_iVal_iCardsClearup',@validatedsupplier=0
		end

		set @logtext='iVal clearup process created Options card for ' + @lolrrp + ' value of £ ' +cast(@cardvalue as varchar) + ' which was incentivised by ' + cast(@incentval as varchar) + '%'
		set @ID=@prefix+cast(@policyid as varchar)
		exec LogEntry @iCardsid=@ID, @userid=@userid, @Data=@claimid, @type=1, @text=@logtext

		set @notetext='iVal clearup process created Options card for ' + @lolrrp + ' value of £ ' +cast(@cardvalue as varchar) + ' which was incentivised by ' + cast(@incentval as varchar) + '%' 
			+ case when isnull(@supplierslist,'') !='' then ' which included the following supplier breakdown: ' +@supplierslist else '' end
		exec ppd3.dbo.NoteCreate @ClaimID=@claimid, @note=@notetext, @userid=@userid, @notetype=0
	commit tran
 end

--we are creating a new card but for an existing policy
if(@dupstage=2)
 begin
 set @ValueType='M'
	begin tran
	select @customerid=customerid from policyheaderdetails where icardsid=@iCardsId

	insert into cards (customerid,nameoncard,cardtype,createdate,createdby) 
	values (@customerid,@nameoncard,@cardtype,@dt,@userid)

	insert into transactions (cardid,cardvalue,type,createdate,createdby,origvalue,incentive,incentiverate) 
	values (scope_identity(),@cardvalue,@ValueType,@dt,@userid,@origvalue,@incentivise,@incentval)

	set @transactionid=scope_identity()

	-- Insert Transaction suppliers if necessary
	insert into transactionsuppliers(TransactionID,SupplierID, RRP)
	select @transactionid,supplierid, rrpvalue
	from @suppliersT

	--Update Auth Requirement on the transaction
	set @authrequirement=dbo.AuthRequirement(@postcode,@transactionid,@cardvalue)

	update transactions
	set authrequirement=@authrequirement, [status]=case when AuthRequirement=0 and @companyid=2 then 1 else 0 end
	where id=@transactionid and [status]=0 and InvoiceBatchNo is null and InvoicedDate is null

	--update policy with ival ref
	update policies set ivalref=@claimid where icardsid=right(@iCardsId,6)

	-- Update Orderitems set action to iVal Options Card
	update ppd3.dbo.OrderItems set
		[action]=@typ+100,
		[status]='SENT',
		stockstatus=10,
		datesentUTC=dbo.SN_TimeZone_ConvertLegacyDateTimeToPPDate(@dt)
	where claimid=@claimid and [type]='O' and [action]=@typ and [action] between 8 and 11

	-- update claims to set excess paid if required
	if(@excess>0)
	begin
		update ppd3.dbo.claims set excesspaidUTC=@dt,excesspaymethod='External_Options' where claimid=@claimid
	end

	-- Insert SP for CPL. SD/MW agreed.
	if exists (select * 	from ppd3.dbo.Claims c join ppd3.dbo.SupplierConfig sc on sc.channel=c.channel and sc.supplierid=6500
			and (excesspaidUTC is not null and sc.SupplierCollectsXS=1)
		where c.claimid=@claimid and excess>0
	)
	begin
		set @icardsfkid=cast(right(@iCardsId,6) as int)
		exec ppd3.dbo.SupplierPayments_Log @claimid=@claimid,@supplierid=6500,@fkid=@icardsfkid, @sendmethod='NV',@suppliercollectsxs=1,@excess=@excess,@userid='SP_iVal_iCardsClearup',@validatedsupplier=0
	end

	set @logtext='iVal clearup process created Options card for ' + @lolrrp + ' value of £ ' +cast(@cardvalue as varchar) + ' which was incentivised by ' + cast(@incentval as varchar) + '%'
	set @ID=@prefix+cast(@policyid as varchar)
	exec LogEntry @iCardsid=@ID, @userid=@userid, @Data=@claimid, @type=1, @text=@logtext

	set @notetext='iVal clearup process created Options card for ' + @lolrrp + ' value of £ ' +cast(@cardvalue as varchar) + ' which was incentivised by ' + cast(@incentval as varchar) + '%' 
		+ case when isnull(@supplierslist,'') !='' then ' which included the following supplier breakdown: ' +@supplierslist else '' end
	exec ppd3.dbo.NoteCreate @ClaimID=@claimid, @note=@notetext, @userid=@userid, @notetype=0

	commit tran
end
GO
