SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[LetterFormatsSelect]

AS

	SELECT letterFormatId, description FROM letterFormats ORDER BY letterFormatId
GO
