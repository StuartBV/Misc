SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetOptionsforCache]
as
set nocount on
declare @tablename varchar(50)
create table #dropdowns_tmp (idnum int identity(1,1)primary key, tablename varchar(50))

insert into #dropdowns_tmp (tablename )
select distinct tablename from syslookup where TableName like 'fnol%'

while exists(select * from #dropdowns_tmp)
 begin
	
	select top 1 @tablename=tablename from #dropdowns_tmp
	
	select tablename as list,code as value,left(description,36) as [text]
	from syslookup
	where TableName=@tablename
	
	delete from #dropdowns_tmp where tablename=@tablename
	
 end

drop table #dropdowns_tmp


select 'fnolusers' as list,u.userid as value,ln.fullname as [text]
from users u 
join ppd3.dbo.LogonNames ln on u.UserID = ln.userid 
where PrimeUser=1 


GO
