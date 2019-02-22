SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CategoriesListL1]
as
DECLARE
@list VARCHAR(8000)

SET NOCOUNT ON
SET @list=''

SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+catname+':'+left(catname,36)
from (
select distinct isnull(c.name,'[Unknown]') catname, c.id [catid]
from fnol_categories c (nolock) 
join fnol_categories c2 (nolock) on c2.parentid=c.id and isnull(c2.parentid,0)!=0 and c.Enabled=1
where isnull(c.parentid,0)=0
)x
order by x.catname

SELECT @list




GO
