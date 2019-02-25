SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[GetPolicyDetails] 
@search varchar(50),
@identity varchar(50),
@userid varchar(50)
as
/*
<SP>
	<Name>GetPolicyDetails</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060510</CreateDate>
	<Referenced>
		<asp>iCardsSearch.asp</asp>
	</Referenced>
	<Overview>Used to check if policy details already exist in database and return various result sets depending on findings</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
declare
@searchcount int,
@iCardsID varchar(50)

set nocount on
set @identity = @identity+'%'


--run check to see if records already exist
if (@search = 'claimno')
	begin
		set @searchcount = (select count(distinct iCardsID) from policies where insuranceclaimno like @identity)
	end
else if (@search = 'surname')
	begin
		set @searchcount = (select count(distinct p.iCardsID) from policies p left join customers c on c.icardsid = p.icardsid where c.lastname like @identity)
	end
else if (@search = 'postcode')
	begin
		set @searchcount = (select count(distinct p.iCardsID) from policies p left join customers c on c.icardsid = p.icardsid where c.postcode like @identity)
	end
else if (@search = 'iCardsID')
	begin
		set @searchcount = (select count(distinct iCardsID) from policies p left join card_companies c on c.id = p.companyid where c.claimnoprefix+cast(p.icardsid as varchar) like @identity)
	end
else if (@search = 'iValRef')
	begin
		set @searchcount = (select count(distinct iCardsID) from policies where iValRef like @identity)
	end

--if more than one record exists then return summary data
if @searchcount>1
begin
	if (@search = 'claimno')
		begin
			select * from policysearch where insuranceclaimno like @identity
		end
	else if (@search = 'surname')
		begin
			select * from policysearch where lastname like @identity
		end
	else if (@search = 'postcode')
		begin
			select * from policysearch where postcode like @identity
		end
	else if (@search = 'iCardsID')
		begin
			select * from policysearch where iCardsID like @identity
		end
	else if (@search = 'iValRef')
		begin
			select * from policysearch where iValRef like @identity
		end
end

else if @searchcount=1 -- only one record exist so return the full data
begin
	if (@search = 'claimno')
		begin
			select @iCardsID = iCardsID from policyheaderdetails where insuranceclaimno like @identity
			exec LastRefUpdate @userid, @iCardsID
			select * from policyheaderdetails where insuranceclaimno like @identity
			select * from policycarddetails where insuranceclaimno like @identity
			select * from policycardvaluedetails where insuranceclaimno like @identity		
		end
	else if (@search = 'surname')
		begin
			select @iCardsID = iCardsID from policyheaderdetails where lastname like @identity
			exec LastRefUpdate @userid, @iCardsID
			select * from policyheaderdetails where lastname like @identity
			select * from policycarddetails where lastname like @identity
			select * from policycardvaluedetails where lastname like @identity
		end
	else if (@search = 'postcode')
		begin
			select @iCardsID = iCardsID from policyheaderdetails where postcode like @identity
			exec LastRefUpdate @userid, @iCardsID
			select * from policyheaderdetails where postcode like @identity
			select * from policycarddetails where postcode like @identity
			select * from policycardvaluedetails where postcode like @identity
		end
	else if (@search = 'iCardsID')
		begin
			select @iCardsID = iCardsID from policyheaderdetails where iCardsID like @identity
			exec LastRefUpdate @userid, @iCardsID
			select * from policyheaderdetails where iCardsID like @identity
			select * from policycarddetails where iCardsID like @identity
			select * from policycardvaluedetails where iCardsID like @identity
		end
	else if (@search = 'iValRef')
		begin
			select @iCardsID = iCardsID from policyheaderdetails where iValRef like @identity
			exec LastRefUpdate @userid, @iCardsID
			select * from policyheaderdetails where iValRef like @identity
			select * from policycarddetails where iValRef like @identity
			select * from policycardvaluedetails where iValRef like @identity
		end
end
else
begin
	select * from policydetails where icardsid like @identity
end
GO
