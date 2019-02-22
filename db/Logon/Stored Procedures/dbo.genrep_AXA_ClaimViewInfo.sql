SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[genrep_AXA_ClaimViewInfo]
@from Varchar(10),
@to Varchar(10)
as
set noCount on
set dateFormat dmy
declare @fd DateTime,@td DateTime
select @fd=Cast(@from as DateTime),@td=DateAdd(d,1,Cast(@to as DateTime))

select [Platform], [Name], [user ID], Client, [Times logged on], [Claims Accessed] from (
	select 'SSO' as Platform, IsNull(u.FirstName + ' ' + u.LastName, u.Username) [Name], u.Username [user ID],ou.Name Client, 
		  (select Count(*) from [SSO-Accounts].dbo.AuthLog where UserId=u.Id and Status=1 and CreateDate between @fd and @td) [Times logged on],
		  (select Count(*) from AuthLog where userid=u.Username and Code=5 and CreateDate between @fd and @td) [Claims Accessed]
	from [SSO-Accounts].dbo.[User] u 
	join [SSO-Accounts].dbo.OrganisationalUnit ou on u.OrganisationalUnitId=ou.Id 
	where u.OrganisationalUnitId in (33, 77, 82, 85, 86, 96)

	union all

	select 'GK' as Platform, u.FName + ' ' + u.SName [Name], al.userid [user ID],c.Name Client, Sum(case when al.Code=1 then 1 else 0 end) [Times logged on],
		  Sum(case when al.Code=5 then 1 else 0 end) [Claims Accessed]
	from AuthLog al join userdata u on u.UserName=al.userid
	join Clients c on c.CID=u.ClientID
	where u.ClientID in (26,25,60,50,76,100,113,116,117)
	and al.CreateDate between @fd and @td and al.Code in (0,5)
	group by u.FName,u.SName,al.userid,c.Name

	/* bad smell here! */

	/*
	union all

	-- ac: 22/08/2018 - now go get the stuff held in the ppd3.[Log] table. this holds data on file downloads etc
	-- added for https://github.com/BeValued/ClaimsControl/issues/806
	select 'CC' as Platform, u.FName + ' ' + u.SName [Name], al.userid [user ID],c.Name Client, sum(case when al.Type=5 then 1 else 0 end) [Times logged on],
		  sum(case when al.Type=5 then 1 else 0 end) [Claims Accessed]
	from [ppd3].dbo.[Log] al join UserData u on u.UserName=al.userid
	join clients c on c.CID=u.ClientID
	where u.ClientID in (26,25,60,50,76,100,113,116,117) -- this is hardcoded for AXA clients
	and al.Date between @fd and @td and al.Type in (0,5)
	group by u.FName,u.SName,al.userid,c.name
	*/

)x where [Times logged on]>0
order by 1 desc, 2, 3


GO
