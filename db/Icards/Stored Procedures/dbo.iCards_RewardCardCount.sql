SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCards_RewardCardCount] AS

select count(*) from icardsrewardcardload ic /*where claimid is not null*/

select 0 /*count(*) from icardsrewardcardload ic where claimid is null*/
GO
