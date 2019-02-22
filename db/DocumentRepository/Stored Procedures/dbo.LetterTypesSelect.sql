SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[LetterTypesSelect]

AS

	SELECT letterTypeId, description FROM letterTypes ORDER BY letterTypeId
GO
