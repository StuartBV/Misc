SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[DuplicatesCheck]
@Policy varchar(50),
@Claim varchar(50),
@iCardsID varchar(50)
as
/*
<SP>
	<Name>DuplicatesCheck</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060515</CreateDate>
	<Referenced>
		<asp>iCardsCreateNew.asp</asp>
	</Referenced>
	<Overview>Used to check if policy details already exist in database</Overview>
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
@PolicyCount int,
@ClaimCount int

set nocount on
-- Comment from Stu: The below should be written in 1 line using a case statement and only one hit of the table

set @PolicyCount = (select count(*) from policyheaderdetails where insurancepolicyno = @Policy and iCardsID <> @iCardsID AND wizarddescription<>'Cancelled')
set @ClaimCount = (select count(*) from policyheaderdetails where InsuranceClaimNo = @Claim and iCardsID <> @iCardsID AND wizarddescription<>'Cancelled')

if(@PolicyCount>0 or @ClaimCount>0)
begin
	select 1 as [check]
	select * from policysearch where (insurancepolicyno = @Policy or InsuranceClaimNo = @Claim) and iCardsID <> @iCardsID AND stage<>'Cancelled'
end
else
begin
	update policies set wizardstage = 3 where icardsid = right(@iCardsID,6)
	select 0 as [check]
end
GO
