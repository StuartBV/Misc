SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LetterSelectById]

	@letterId	int 

AS

	SELECT LID LetterID, claimId, FK_ID, letterType, letterFormat, createDate, letterData, t.FooterType, t.appendFooter,t.ShowContainer
	FROM Letters l
	join LetterTypes t on t.letterTypeId=l.letterType
	WHERE LID = @letterId
GO
