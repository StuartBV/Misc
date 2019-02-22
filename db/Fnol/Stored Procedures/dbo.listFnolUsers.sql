SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[listFnolUsers] as 

declare @list varchar(max)=''
set nocount on

select @list=@list+case when @list<>''then ',' else '' end+userid+':'+left(fullname,36) from (
	select u.userid,ln.fullname
	from users u join ppd3.dbo.LogonNames ln on u.UserID = ln.userid 
	where PrimeUser=1 
)x
order by x.userid

select @list
GO
