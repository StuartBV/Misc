SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsStartNewUpdate1]
@iCardsID varchar(50),
@wizardstage int,
@SePScode varchar(15),
@insurancepolicyno varchar(50),
@insuranceclaimno varchar(50),
@incidentdate varchar(12),
@contactname varchar(50),
@contactphone varchar(50),
@userid UserID
as

update p set
	wizardstage=@wizardstage,
	SePScode=@SePScode,
	insurancecoid=s.clientID,
	origoffice=s.office,
	insurancepolicyno=@insurancepolicyno,
	insuranceclaimno=@insuranceclaimno,
	incidentdate=@incidentdate,
	contactname=@contactname,
	contactphone=@contactphone,
	alteredby=@userid,
	altereddate=getdate()
from policies p join card_companies cc on cc.ID=p.companyID and cc.id=2
join ppd3.dbo.SePSbranches s on isnull(case when p.SePScode='0' then @SePScode else p.SePScode end,@SePScode)=s.AccountRef
where p.iCardsID=cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)
GO
