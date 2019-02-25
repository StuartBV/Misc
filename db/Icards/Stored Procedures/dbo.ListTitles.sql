SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ListTitles] AS

select [description]
from ppd3.dbo.Syslookup
where tablename='Title'
AND code IN ('a', 'b', 'c', 'd', 'h', 'l')
order by code
GO
