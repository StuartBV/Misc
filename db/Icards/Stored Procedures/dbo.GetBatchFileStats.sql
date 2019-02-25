SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetBatchFileStats] as
/*
<SP>
	<Name>GetBatchFileStats</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20060619</CreateDate>
	<Referenced>
		<asp>iCardsGenerateBatchFiles.asp</asp>
	</Referenced>
	<Overview>Called from iCardsGenerateBatchFiles.asp which displays how many cards are to be processed</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
SELECT sys.description AS CardType, isnull(x.actions,0) AS actions 
FROM syslookup sys 
LEFT JOIN (
	select s.description, count(distinct cv.[id]) actions
	from dbo.Card_companies AS cc 
	JOIN dbo.Policies AS p ON cc.ID = p.CompanyID 
	JOIN dbo.Customers AS cu ON cu.iCardsID = p.ICardsID 
	JOIN cards c on cu.id = c.customerid
	join transactions cv on c.[id]=cv.cardid
	right outer join syslookup s on c.cardtype = s.code
	where cv.status in (0,1)
	and s.tablename='cardtype'
	and p.wizardstage=4 AND p.cancelreason IS NULL
	and (cv.authrequirement=0 or (cv.authrequirement>0 and cv.authdate is not null))
	group by s.[description]
)x ON x.description=sys.description
WHERE sys.tablename='cardtype'
GO
