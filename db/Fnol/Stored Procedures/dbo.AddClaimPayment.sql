SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AddClaimPayment]
@id INT,
@userid VARCHAR(50)
AS

SET NOCOUNT ON
SET DATEFORMAT DMY

BEGIN TRAN

INSERT INTO FNOL_ClaimPayments (ClaimID,TransDate,status,CreatedBy,CreateDate) 
VALUES (@id,convert(varchar(12),getdate(),13),'REC',@userid,GETDATE()) 

COMMIT
GO
