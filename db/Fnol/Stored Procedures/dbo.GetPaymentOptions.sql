SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[GetPaymentOptions]
@rowid int,
@accesslevel tinyint
as
DECLARE
@list VARCHAR(8000)

SET NOCOUNT ON
SET @list=''

--SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+'"'+s.code+'":"'+left(s.description,36)	+'"'
SELECT @list=@list+CASE WHEN @list<>''THEN ',' ELSE '' END+s.code+':'+left(s.description,36)
FROM sysLookup s (nolock)
join fnol_claimpayments c (nolock) on c.id=@rowid and s.TableName = 'FNOL - PayCode'
join sysLookup s2 (nolock) on s2.TableName='userrole' and s2.ExtraDescription='fnol' and s2.code=cast(@accesslevel as varchar)
join sysLookup s3 (nolock) on s3.TableName='FNOL - PayCode' and s3.code=isnull(c.status,'REC')
where s.flags>s3.flags -- limit list to status not yet used
and s.flags<=s2.ExtraCode -- limit list by user role
order by s.flags

SELECT '{'+@list+'}' 



GO
