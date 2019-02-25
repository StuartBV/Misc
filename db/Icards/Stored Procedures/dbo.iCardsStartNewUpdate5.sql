SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsStartNewUpdate5]
@iCardsID varchar(50),
@wizardstage int,
@duplicates varchar(1000)='',
@userid varchar(20)
as
/*
<SP>
	<Name>iCardsStartNewUpdate5</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060516</CreateDate>
	<Referenced>
		<asp>iCardsStartNewUpdate.asp</asp>
	</Referenced>
	<Overview>Called from iCardsStartNewUpdate.asp to auto save new policy creation on iCardsStartNew.asp</Overview>
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
@logtext varchar(200),
@status int,
@authcode int

--select @authcode = authrequirement from policycardvaluedetails where icardsid = replace(@iCardsID,'FIS','')
--set @status = 0

if @wizardstage=2
begin
   set @logtext='Initial Policy Data entry stage completed'
end

if @wizardstage=3
begin
   set @logtext='Possible duplicate policies identified but deemed valid: '+@duplicates
end

if @wizardstage=4
begin
	set @logtext='Policy data checked and finalised'
end

--if @authcode=0
--begin
--	set @status = 1
--end

BEGIN TRANSACTION

update p set
wizardstage=@wizardstage,
status=1
from policies p
join card_companies cc on cc.ID=p.companyID and cc.id=2
where iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)

if @wizardstage>1
begin
	exec LogEntry @iCardsid=@iCardsID, @userid=@userid, @type=2, @text=@logtext
end

COMMIT TRANSACTION
GO
