SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LetterSearch]
@claimId int = 0,
@fk_id int = 0,
@letterType tinyint = 0,
@letterFormat tinyint = 0,
@fromDate datetime = NULL,
@toDate datetime = NULL,
@sortBy int = 5,
@sortOrder tinyint = 1,
@channel varchar(30)=''
as
set nocount on

if @channel ='' or @channel = '0'
begin
	select @channel=''
end 
select @fromdate=isnull(@fromdate,'20070506'), @todate=isnull(@todate,getdate())+1

select l.LID LetterID, l.claimId, l.letterType, l.letterFormat, LT.appendFooter, l.createDate, cu.title + ' ' + cu.FName + ' ' + cu.LName AS fullName, isNull(convert(char(10),l.printdate,103) +' ' + convert(char(5),l.printdate,108),'Never') PrintDate
from Letters l
left join ppd3.dbo.Claims c ON l.ClaimId = c.ClaimId AND @channel=case when @channel !='' then c.channel else '' end
left join ppd3.dbo.Customers cu ON cu.id=c.CustId
left join dbo.LetterTypes lt on lt.letterTypeId = l.letterType
where (@claimId=0 or l.claimId=@claimId)
	and (@FK_ID=0 or l.FK_ID=@FK_ID )
	and ( @letterType=0 or l.letterType=@letterType) 
	and (@letterFormat=0 or l.letterFormat=@letterFormat)
	and l.createDate between @fromdate and @todate
order by 
	case when @sortOrder = 2 then null
		when @sortBy = 2 then l.claimId
		when @sortBy = 3 then l.letterType
		when @sortBy = 4 then l.letterFormat
		when @sortBy = 5 then l.createDate
		when @sortBy = 6 then cu.title + ' ' + cu.FName + ' ' + cu.LName
		else l.createDate
	end	asc,
	case when @sortOrder = 1 then NULL
	when @sortBy = 2 then l.claimId
	when @sortBy = 3 then l.letterType
	when @sortBy = 4 then l.letterFormat
	when @sortBy = 5 then l.createDate
	when @sortBy = 6 then cu.title + ' ' + cu.FName + ' ' + cu.LName
	else l.createDate
	end desc
GO
