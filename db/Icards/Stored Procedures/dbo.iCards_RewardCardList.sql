SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCards_RewardCardList] 

@action int
/*
	action; 0: success, 1: failed
*/
AS

set nocount on

if @action=1
begin
	select policyno,title + ' ' + initials + ' ' + sname [name], address1, town, county, postcode from icardsrewardcardload ic 
	where claimid is null and claimid is not null		/* 	will return empty recordset	*/
end
else
begin
	select policyno,title + ' ' + initials + ' ' + sname [name], address1, town, county, postcode from icardsrewardcardload ic 
	/*where claimid is not null*/
end
GO
