SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Derek Francis>
-- Create date: <15 Aug 2008>
-- Description:	<procedure used to create a new policy from an old policy>
-- =============================================
CREATE PROCEDURE [dbo].[NewPolicy]
	-- Add the parameters for the stored procedure here
	@fname VARCHAR(50),
	@lname VARCHAR(50),
	@policyno VARCHAR(100),
	@serviceno VARCHAR(100),
	@userid VARCHAR(50)
AS
DECLARE
@id INT

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set QUOTED_IDENTIFIER Off
	SET NOCOUNT ON
	SET DATEFORMAT dmy

	BEGIN TRAN	
	INSERT INTO FNOL_Customers (Fname,Lname,CreateDate,CreatedBy) 
	VALUES (@fname,@lname,GETDATE(),@userid) 

	SET @id=SCOPE_IDENTITY()

	INSERT INTO FNOL_Policy (PolicyNo,CustomerID,companyID,ServiceNo,CreatedBy,CreatedDate) 
	VALUES (@policyno,@id,1,@serviceno,@userid,GETDATE()) 

	SET @id=SCOPE_IDENTITY()

	COMMIT TRAN	

	SELECT @id AS PolicyID
	
END
GO
