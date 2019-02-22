SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ELMAH_GetErrorsXml]
@Application nvarchar(60),
@PageIndex int=0,
@PageSize int=15,
@TotalCount int output
as 
set nocount on

declare @FirstTimeUTC datetime, @FirstSequence int, @StartRow int, @StartRowIndex int

select @TotalCount=count(*) 
from ELMAH_Error
where [Application]=@Application

-- Get the ID of the first error for the requested page

set @StartRowIndex=@PageIndex * @PageSize + 1

if @StartRowIndex <= @TotalCount
begin
	set rowcount @StartRowIndex

	select @FirstTimeUTC=TimeUtc, @FirstSequence=[Sequence]
	from ELMAH_Error
	where [Application]=@Application
	order by TimeUtc desc, [Sequence] desc

end
else
begin
	set @PageSize=0
end

-- Now set the row count to the requested page size and get
-- all records below it for the pertaining [Application].

set rowcount @PageSize

select errorId=ErrorId, [Application], Host, [Type], [Source], [Message], [User], StatusCode, convert(varchar(50), TimeUtc, 126) + 'Z' [Time]
from 
ELMAH_Error
where [Application]=@Application and TimeUtc <= @FirstTimeUTC and [Sequence] <= @FirstSequence
order by TimeUtc desc, [Sequence] desc
for xml auto

GO
