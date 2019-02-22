SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DataMig_Notes]
AS

SET DATEFORMAT dmy

BEGIN tran

INSERT INTO FNOL_Notes (ClaimID,Note,CreateDate,CreatedBy,NoteType,NoteReason)

SELECT c.claimid,dm.[Descr'n],CAST(dm.[Trans'n Dt] AS DATETIME),dm.Handler,100,s.code
fROM fnol_DataMig_notes dm JOIN FNOL_Claims c ON dm.[claim no]=c.clientrefno
JOIN syslookup s ON dm.EXP=s.description AND s.tablename='FNOL - NoteCode'
ORDER BY CAST(dm.[Trans'n Dt] AS DATETIME),c.claimid

COMMIT
--rollback

GO
