SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[IcardsHoldUnhold]
@CustomerID int,
@status int
AS
BEGIN
	SET NOCOUNT ON;
	if @status = 1 --on hold
	BEGIN
		Update Cards set CardOnHold = 'Y' where CustomerID = @CustomerID
	END
	if @status = 0 -- not on hold
	BEGIn
		Update Cards set CardOnHold = 'N' where CustomerID = @CustomerID
	END
	

END
--raiserror('hi',1,18)
GO
