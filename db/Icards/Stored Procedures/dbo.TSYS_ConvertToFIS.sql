SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[TSYS_ConvertToFIS]
@cardid int,
@balance money
as

declare @icardsid int


SELECT @icardsid=replace(icardsid,'CNU','') 
FROM dbo.PolicyDetails 
where cardid=@cardid


exec dbo.TysisReissue @icardsid,@balance
GO
