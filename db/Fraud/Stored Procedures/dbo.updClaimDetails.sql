SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
<SP>
	<Name>updClaimDetails</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20080507</CreateDate>
	<Overview>used to update finance & police info relating to a claim</Overview>
	<Changes>
		<Change>
			<User>DerekF</User>
			<Date>18/9/2008</Date>
			<Comment>converted claimid to varchar for FNOL integration</Comment>
		</Change>
	</Changes>
</SP>
*/
CREATE PROCEDURE [dbo].[updClaimDetails]
@claimID int,
@userid VARCHAR(50),
@amountclaimed MONEY,
@initialreserve MONEY,
@excess MONEY,
@suminsured MONEY,
@policestation varchar(50),
@policetel varchar(50),
@crimerefno varchar(50),
@risk smallint,
@datereported varchar(20)
AS
DECLARE
@fin VARCHAR(10),
@tier SMALLINT,
@status smallint
SET NOCOUNT ON
BEGIN tran

UPDATE claimproperties SET Amount_Claimed=@amountclaimed,Initial_Reserve=@initialreserve,Excess=@excess,Sum_Insured=@suminsured,
policestation=@policestation,policephone=@policetel,crimerefno=@crimerefno,datereported=@datereported,
AlteredBy=@userid,AlteredDate=GETDATE() WHERE ClaimID=@claimID

update claims set excess=@excess where claimid=@claimid

update fraud set risk=@risk where claimid=@claimID

SELECT @fin=fin,@tier=CurrentTier,@status=status FROM fraud WHERE claimid=@claimID
EXEC LogEvent @FIN = @fin, @UserID = @userid, @Tier = @tier, @Status = @status,	@Action = 97
COMMIT
GO
