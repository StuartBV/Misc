SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AddClaimItem]
@id INT,
@userid VARCHAR(50),
@asset VARCHAR(50),
@makemodel VARCHAR(100),
@desc VARCHAR(250),
@amount MONEY
AS

SET NOCOUNT ON
SET DATEFORMAT DMY
declare 
@clientref varchar(20),
@items int 


BEGIN

select @clientref=clientrefno from fnol_claims where ClaimID=@id
select @items=count(*)+1 from dbo.FNOL_ClaimItems where ClaimID=@id

INSERT INTO FNOL_ClaimItems (ClaimID,CreatedBy,CreatedDate,AssetNo) 
VALUES (@id,@userid,GETDATE(),@clientref+'/'+cast(@items as varchar) )

END
GO
