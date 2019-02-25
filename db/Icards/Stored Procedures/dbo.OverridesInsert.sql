SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[OverridesInsert]
@iCardsID varchar(20),
@UserID varchar(20),
@SupervisorID varchar(20),
@Desc varchar(100)

AS

set nocount on
set transaction isolation level read uncommitted
declare @Status varchar(50)
declare @WizardStage smallint

select @Status=status,@WizardStage=WizardStage 
from policies p
JOIN card_companies cc on cc.ID=.p.companyID
where iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)

insert into [Log] (iCardsID, CreateDate, UserID,SupervisorID,Type,[Text], Status, WizardStage) 
values(@iCardsID, getdate(), @UserID,@SupervisorID,'100',@Desc, @Status, @WizardStage)

set transaction isolation level read committed


GO
