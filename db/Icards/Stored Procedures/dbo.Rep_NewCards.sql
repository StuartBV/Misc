SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Rep_NewCards] 
@headers tinyint=0
AS
set transaction isolation level read uncommitted
SELECT [CardType], [Qty], [Value] from
(
	SELECT 'A' seq, 'Card Type' [CardType], 'Qty' [Qty], 'Total Value' [Value] WHERE @headers=1
	union ALL 
	SELECT 'B' seq, 
		sys.description AS [CardType],
		cast(isnull(x.qty,0) AS varchar) [Qty],
		cast(isnull(x.value,0) AS varchar) [Value]
	FROM syslookup sys
	LEFT JOIN cards c ON sys.code=c.cardtype AND sys.TableName='CardType'
	LEFT JOIN transactions t ON t.cardid=c.ID
	LEFT JOIN (
		SELECT 
			sys.description AS [CardType], 
			count(*) [Qty],
			sum(t.cardvalue) [Value]
		FROM transactions t
		LEFT JOIN cards c ON t.cardid=c.ID
		LEFT JOIN syslookup sys ON sys.code=c.cardtype AND sys.TableName='CardType'
		WHERE t.createdate BETWEEN getdate()-1 AND getdate()
		AND t.type='M'
		GROUP BY sys.Description
	)x ON x.cardtype=sys.description
	WHERE sys.TableName='CardType'
	GROUP BY sys.Description, x.qty, x.value
)y
order by seq, [CardType]
set transaction isolation level read committed


GO
