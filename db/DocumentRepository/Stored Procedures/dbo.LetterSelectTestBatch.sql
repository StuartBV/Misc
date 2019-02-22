SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LetterSelectTestBatch]
AS
set nocount on

SELECT	L.LID LetterID,
		L.claimId,
		L.letterType as LetterType,
		L.letterFormat,
		L.createDate,
		'['+c.channel +']'+ P.title + ' ' + P.FName + ' ' + P.LName AS fullName,
		isNull(convert(char(10),L.printdate,103) +' ' + 
		convert(char(5),L.printdate,108),'Never') PrintDate
FROM Letters L 
JOIN PPD3.dbo.Claims C ON L.ClaimId = C.ClaimId
JOIN PPD3.dbo.Customers P ON C.CustId = P.ID
join (
	-- Select one of Each letter Type from the DB per channel
	select max(lid) Lid, lettertype, c.channel
	from Letters l with (nolock)
	join ppd3.dbo.Claims c on l.claimid=c.claimid
	join ppd3.dbo.Channels ch on ch.channel=c.channel
	where l.lettertype not in (9,10) -- Dont need invoices
	group by LetterType, c.channel
	
	
)tl on l.lid=tl.lid
order by l.lettertype
GO
