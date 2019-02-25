SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[FIS_ActionException]
@id int
as

set nocount on

update dbo.FisExceptions
set Actioned=1
where RECID=@id


update dbo.PolicyDetails
set Status=1
where TransactionID=@id
and (
	(AuthRequirement>0 and AuthBy is not null)
	or AuthRequirement=0
	)
GO
