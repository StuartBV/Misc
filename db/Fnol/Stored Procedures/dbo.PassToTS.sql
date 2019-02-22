SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PassToTS]
@ClaimID int,
@UserID UserID
as

set nocount on
set dateformat dmy

begin tran

exec Fraud.dbo.PassFNOLtoFraud @claimID=@ClaimID, @UserID=@UserID
update FNOL_Claims set [Status]='INV' where ClaimID=@ClaimID
exec AddNoteToClaim @ClaimID=@ClaimID,  @note='Passed to Technical Services for Screening',  @userid=@UserID, @notetype=100,  @notereason=40 

commit tran
GO
