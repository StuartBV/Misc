SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[GroupsList]
as
DECLARE
@list VARCHAR(8000)

SET NOCOUNT ON
SET @list=''

SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+catname+':'+left(catname,36)
from (
select distinct isnull(c.catname,'[Unknown]') catname, c.catid
from fnol_groups c (nolock) 
)x
order by x.catname

SELECT @list




GO
