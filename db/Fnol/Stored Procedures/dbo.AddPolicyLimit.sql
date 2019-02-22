SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddPolicyLimit]
@id INT,
@userid VARCHAR(50),
@limittype VARCHAR(10),
@suminsured MONEY,
@excess MONEY
AS

SET NOCOUNT ON
SET DATEFORMAT DMY

BEGIN

INSERT INTO FNOL_PolicyLimits (PolicyID,SumInsured,Excess,[Type],CreatedBy,CreatedDate) 
VALUES (@id,@suminsured,@excess,@limittype,@userid,GETDATE()) 

END
GO
