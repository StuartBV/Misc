SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[AutoFNOL_GetMessageLogs]
@page int=1, -- Page to list
@pagesize int=10 -- Items per page
AS
BEGIN

declare @start smallint,@end smallint,@MaxReviewChars int,@sectionID SMALLINT,@sql VARCHAR(8000),@rows int,@pages int
set @start=(@page*@pagesize)-@pagesize+1
set @end=@page*@pagesize
SET @sql=""

set dateformat dmy	
SET NOCOUNT ON

create table #tmp (idnum int identity(1,1)primary key,
ID int,createdate datetime,original_message text,transformed_message text,
insuranceclaimno varchar(100),status varchar(50),pushedtoppd3 datetime,CMS_ClaimID int,PDF_Created datetime
)

insert into #tmp (ID,createdate,original_message,transformed_message,insuranceclaimno,status,pushedtoppd3,CMS_ClaimID,PDF_Created) 
SELECT top 1000 ID,createdate,original_message,transformed_message,insuranceclaimno,status,pushedtoppd3,CMS_ClaimID,PDF_Created 
FROM AUTOFNOL_MessageLog with (nolock)
order by id desc

select @rows=coalesce(max(idnum),0),@pages=coalesce(round(max(idnum)/cast(@pagesize as decimal(7,2))+0.49,0),0) from #tmp;

SELECT ID,createdate,original_message,transformed_message,insuranceclaimno,status,pushedtoppd3,CMS_ClaimID,PDF_Created,@rows [Rows],@pages [Pages]
FROM #tmp WHERE idnum between @start and @end

DROP TABLE #tmp

END


GO
