SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LetterInsert] 
@letterId int output,
@claimId int,
@fk_id int=0,
@letterType tinyint,
@letterFormat tinyint,
@letterData image,
@letterPrinted bit,
@userid varchar(50)='sys'

as 
declare @printDate datetime, @printedBy varchar(50)
select @printDate=case when @letterPrinted=1 then getdate() else null end,
	   @printedBy = case when @letterPrinted = 1 then @userid else null end

select @fk_id=isnull(max(fk_id)+1,@fk_id)
from Letters l join LetterTypes lt on lt.AutoGenerateFkId=1 and lt.letterTypeId=@letterType
where l.claimId=@claimID and l.letterType=@LetterType 

select @letterId=LID from Letters
where claimId=@claimId and fk_id=@fk_id and letterType=@letterType

if @@rowcount=1
begin
	update Letters set 
		letterFormat=@letterFormat, 
		letterData=@letterData, 
		printDate=@printDate ,
		PrintedBy=@printedBy,
		AlteredBy=@userid,
		AlteredDate=getdate()
	where LID=@letterID
end

else
begin
	insert into Letters (claimId, fk_id, letterType, letterFormat, letterData, printDate,createdBy,printedBy)
	values (@claimId, @fk_id, @letterType, @letterFormat, @letterData, @printDate, @userid, @printedBy)
	select @letterid=scope_identity()
end

insert into PPD3..Log 
        ( ClaimID ,Date ,UserID ,Type ,Data ,Text )
values  ( @claimid ,getdate() ,@userid ,'38' ,@lettertype ,'Letter Printed' )

return @letterid

GO
