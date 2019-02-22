SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CategoriesListL3]
@parent varchar(200)
as
set nocount on
declare @list varchar(8000)=''

set transaction isolation level read uncommitted

select @list=@list+case when @list<>''then ',' else '' end+'"'+catname+'":"'+left(catname,36)	+'"' from (
	select distinct sub.name [catname]
	from ppd3.dbo.ice_categories c 
	join ppd3.dbo.ice_categories sub on c.ID=sub.parentid
	where c.name=@parent and c.[Enabled]=1
)x
order by x.catname

select '{'+@list+'}'
GO
