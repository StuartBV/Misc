SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsStartNew] 
@userid varchar(20)
as

set nocount on

declare
@policyid int,
@prefix varchar(3),
@logtext varchar(200),
@ID varchar(50)

BEGIN TRANSACTION

set @prefix = (select claimnoprefix from card_companies where [id] = 2)

insert into policies (companyid,wizardstage,createdate,createdby) values (2,1,getdate(),@userid)
set @policyid = SCOPE_IDENTITY()
insert into customers (iCardsid,companyid,createdate,createdby) values (SCOPE_IDENTITY(),1,getdate(),@userid)
update policies set customerid = SCOPE_IDENTITY() where icardsid = @policyid
insert into cards (customerid,createdate,createdby) values (SCOPE_IDENTITY(),getdate(),@userid)
insert into transactions (cardid,createdate,createdby) values (SCOPE_IDENTITY(),getdate(),@userid)

set @logtext = 'Initial Options card record created'
set @ID = @prefix+cast(@policyid as varchar)
exec LogEntry @iCardsid=@ID, @userid=@userid, @type=2, @text=@logtext

COMMIT TRANSACTION

select @prefix+cast(@policyid as varchar) as iCardsID
GO
