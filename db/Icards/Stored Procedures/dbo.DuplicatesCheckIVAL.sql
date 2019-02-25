SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DuplicatesCheckIVAL]
@Policy varchar(50),
@Fname varchar(50),
@Lname varchar(50),
@postcode varchar (8),
@cardtype int=0,
@cardtypeA varchar(20)=''
as
/*
<SP>
	<Name>DuplicatesCheckIVAL</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060522</CreateDate>
	<Referenced>
		<asp>iCardsProcessFrame.asp</asp>
	</Referenced>
	<Overview>Used to check if policy user already has ival card</Overview>
	<Changes>
		<Change>
			<User>DerekF</User>
			<Date>20060524</Date>
			<Comment>amended to return results of existing cards even if not ival cards</Comment>
		</Change>
	</Changes>
</SP>
*/
declare 
@ClaimCountival int,
@ClaimCount int

set nocount on

IF @cardtype=1
	SET @cardtypeA='Aviva' 
IF @cardtype=2
	SET @cardtypeA='Aviva' 
IF @cardtype=3
	SET @cardtypeA='iVal' 
IF @cardtype=4
	SET @cardtypeA='iVal Jewellery' 


select
@ClaimCountival=sum( CASE when insurancepolicyno =@Policy AND firstname=@Fname AND lastname=@Lname AND postcode=@postcode and cardtype=@cardtypeA then 1 else 0 end ),
@ClaimCount = sum( case when insurancepolicyno = @Policy AND firstname=@Fname AND lastname=@Lname AND postcode=@postcode and cardtype!=@cardtypeA then 1 else 0 end )
from policydetails
WHERE cancelreason IS NULL

if(@ClaimCountival>0)
begin
	select 1 as [check]
	select * from policysearch where insurancepolicyno = @Policy 
	AND cardtype = @cardtypeA
end
else if(@ClaimCount>0)
begin
	select 2 as [check]
	select * from policysearch where insurancepolicyno = @Policy 
	AND cardtype != @cardtypeA
end
else
begin
	select 0 as [check]
end
GO
