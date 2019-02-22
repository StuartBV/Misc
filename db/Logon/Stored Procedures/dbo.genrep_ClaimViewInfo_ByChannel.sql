SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[genrep_ClaimViewInfo_ByChannel]
@from varchar(10),
@to varchar(10),
@channel varchar(50)=''
as
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select [Platform], [Name], [user ID], Client, InsCo, [Times logged on], [Claims Accessed] from (
	select 'SSO' as Platform, isnull(u.FirstName + ' ' + u.LastName, u.Username) [Name], u.Username [user ID],ou.Name Client, i.name [InsCo],ou.ChannelList,
		  (select count(*) from [SSO-Accounts].dbo.AuthLog where UserId=u.Id and Status=1 and CreateDate between @fd and @td) [Times logged on],
		  (select count(*) from AuthLog where userid=u.Username and Code=5 and CreateDate between @fd and @td) [Claims Accessed]
	from [SSO-Accounts].dbo.[User] u 
	join [SSO-Accounts].dbo.OrganisationalUnit ou on u.OrganisationalUnitId=ou.Id 
	join [SSO-Accounts].dbo.OrganisationalUnitPaths p on p.Id = ou.Id
	left join ppd3..InsuranceCos i on i.id=ou.InscoId
	where @channel='' or ou.ChannelList like '%'+@Channel+'%'
	union all
	select 'GK' as Platform, u.FName + ' ' + u.SName [Name], al.userid [user ID],c.Name Client,  i.name [InsCo],c.channel,
		sum(case when al.code=1 then 1 else 0 end) [Times logged on],
		sum(case when al.code=5 then 1 else 0 end) [Claims Accessed]
	from AuthLog al 
	join UserData u on u.UserName=al.userid
	join clients c on c.CID=u.ClientID
	join ppd3..InsuranceCos i on c.InsuranceCoID=i.id
	where al.CreateDate between @fd and @td and al.code in (0,5)
	and c.Channel like @Channel
	group by u.FName,u.SName,al.userid,c.name, i.name, c.channel
)x where [Times logged on]>0
order by 1 desc, 2, 3



GO
