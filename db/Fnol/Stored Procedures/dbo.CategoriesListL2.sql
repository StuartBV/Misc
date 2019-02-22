SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[CategoriesListL2]
	@parent varchar(200)
as

DECLARE
@list VARCHAR(8000)

SET NOCOUNT ON
SET @list=''

SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+catname+':'+catname
from (
select distinct 
	sub.name [catname]
from fnol_categories c (nolock) 
join fnol_categories sub (nolock) on c.ID=sub.parentid and isnull(sub.parentid,0)!=0 and c.Enabled=1
where c.name=@parent and c.[Enabled]=1
)x
order by x.catname

SELECT @list
GO
