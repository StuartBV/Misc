SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[usertracking] as
SELECT fl.logid,fl.fin,c.claimid,c.claimno,fl.bookingid,fl.TransDate,fl.UserId,fl.TierStage,s1.Description status,s2.Description actiontaken 
FROM FraudLog fl JOIN sysLookup s1 ON fl.status=s1.code AND s1.tablename='FraudStatus'
JOIN sysLookup s2 ON fl.actiontaken=s2.code AND s2.tablename='actiontaken'
JOIN fraud f with (NOLOCK) ON f.fin=fl.FIN
JOIN claims c with (NOLOCK) ON f.ClaimID = c.ClaimID






GO
