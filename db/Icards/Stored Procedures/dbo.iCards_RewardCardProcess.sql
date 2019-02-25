SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCards_RewardCardProcess] 

@userid varchar(50)

AS

set nocount on
declare cursoricard cursor local for

select [id] from icardsrewardcardload ic
/*where ic.claimid is not null*/

declare
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
	@nameoncard varchar(19),
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
	@typ int


--set @cardvalue=25.00
set @cardtype=5

set @cardoption=null
set @incentivise=null
set @cardid=0
set @origvalue=null
set @iCardsId=''
set @incentval=0
/*
set @lolrrp=
*/
set @dupstage=0
set @typ=98

declare @id int


open cursoricard

fetch next from cursoricard into @id
while @@fetch_status=0
begin

select 
	@claimid	=null,
	@sepscode	=null,
	@title		=ic.title,
	@firstname	=null,
	@lastname	=ic.sname,
	@address1	=ic.address1,
	@address2	=ic.address2,
	@city		=ic.town,
	@county	=ic.county,
	@postcode	=ic.postcode,	
	@phone	=null,
	@insurancepolicyno=ic.policyno,
	@insuranceclaimno=null,
	@origoffice	=null,
	@incidentdate	=null,
	@nameoncard	=left(ic.initials,1)+' '+left(ic.sname,17),
	@insurancecoid	=null,
	@cardvalue=ic.amount
from icardsrewardcardload ic 
where [id]=@id

exec iVal_iCardsClearup
	@claimid,
	@sepscode,
	@title,
	@firstname,
	@lastname,
	@address1,
	@address2,
	@city,
	@county,
	@postcode,
	@phone,
	@cardtype,
	@cardvalue,
	@cardoption,
	@nameoncard,
	@insurancecoid,
	@insurancepolicyno,
	@insuranceclaimno,
	@origoffice,
	@incidentdate,
	@incentivise,
	@cardid,
	@origvalue,
	@iCardsId,
	@incentval,
	@lolrrp,
	@dupstage ,
	@typ,
	@userid


fetch next from cursoricard into @id
end
deallocate cursoricard
GO
