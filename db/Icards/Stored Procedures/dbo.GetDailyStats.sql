SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetDailyStats]
as
set nocount on

declare @created int, @ival int, @unfinished int, @auth1 int, @auth2 int, @auth3 int, @TSYStoupload int, @FIStoupload int, @incent int,
	@invoiced int, @avg money, @FisException int, @dt datetime=getdate()

select @created=isnull(sum(case when convert(varchar(12),p.createdate,113)=convert(varchar(12),@dt,113) and p.ivalref is null then 1 else 0 end) , 0),
@unfinished=isnull(sum(case when p.wizardstage between 1 and 3 and p.cancelreason is null then 1 else 0 end) , 0)
from Card_companies as cc join Policies as p on cc.ID = p.CompanyID 
join Customers as cu on cu.iCardsID = p.ICardsID 
join Cards as cd on cd.CustomerId = cu.ID 
where p.wizardstage > 0

select
@auth1=isnull(sum(case when cv.authrequirement=1 and cv.authdate is null and p.wizardstage=4 and p.cancelreason is null then 1 else 0 end) , 0),
@auth2=isnull(sum(case when cv.authrequirement=2 and cv.authdate is null and p.wizardstage=4 and p.cancelreason is null then 1 else 0 end) , 0),
@auth3=isnull(sum(case when cv.authrequirement=3 and cv.authdate is null and p.wizardstage=4 and p.cancelreason is null then 1 else 0 end) , 0),
@ival=isnull(sum(case when convert(varchar(12),p.createdate,113)=convert(varchar(12),@dt,113) and p.ivalref is not null and cv.cardvalue != 0 then 1 else 0 end) , 0),
@TSYStoupload=isnull(sum(case when cv.[status] in (0,1) and p.wizardstage=4 and p.cancelreason is null and (cv.authrequirement=0 or (cv.authrequirement>0 and cv.authdate is not null)) and cc.id=1 then 1 else 0 end) , 0),
@FIStoupload=isnull(sum(case when cv.[status] = 1 and p.wizardstage=4 and p.cancelreason is null and (cv.authrequirement=0 or (cv.authrequirement>0 and cv.authdate is not null)) and cc.id=2 then 1 else 0 end) , 0),
@incent=isnull(sum(case when convert(varchar(12),p.createdate,113)=convert(varchar(12),@dt,113) and cv.incentive=1 then 1 else 0 end) , 0),
@invoiced=isnull(sum(case when convert(varchar(12),cv.invoiceddate,113)=convert(varchar(12),@dt,113) then 1 else 0 end) , 0),
@avg=isnull(round(avg(case when convert(varchar(12),p.createdate,113)=convert(varchar(12),@dt,113) then cv.cardvalue end),2),0),
@FisException=count(fe.id)
from Card_companies as cc join Policies as p on cc.ID = p.CompanyID 
join Customers as cu on cu.iCardsID = p.ICardsID 
join Cards as cd on cd.CustomerId = cu.ID 
join transactions as cv on cv.CardID = cd.ID
left join FisExceptions fe on fe.CardID=cv.CardID and fe.RECID=cv.id and fe.Actioned=0
where p.wizardstage > 0

select cards_created=@created,ival_options=@ival,unfinished_cards=@unfinished,
cards_auth1=@auth1,cards_auth2=@auth2,cards_auth3=@auth3,
TSYS_cards_toupload=@TSYStoupload,FIS_cards_toupload=@FIStoupload,FIS_Exceptions=@FisException,
cards_incentivised=@incent,cards_invoiced=@invoiced,avg_value=@avg
GO
