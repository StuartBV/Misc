SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[AxaMessageDetails]
AS
select 	m.CMSClaimID as Claimid,
		axa.EdiTrackMessageID, 
		axa.EdiTrackReference, 
		axa.SupplierName, 
		axa.ClaimNumber,
		axa.Workstream,
		axa.SourceClaimSystem
from  AutoFnol.dbo.[Messages] m with(nolock) 
join AutoFnol.dbo.MessageLog_AXA axa with(nolock) on m.MessageID=axa.MessageID
--union all
--select axl.ClaimID,
--		axl.MessageId,
--		ai.ediTRACKReference,
--		ai.SupplierName,
--		ai.ClaimNumber,
--		ai.Workstream,
--		ai.SourceClaimSystem
--from Webservices.dbo.AxaXML_Log as axl with(nolock)
--join WebServices.dbo.AxaInstruction as ai with(nolock) on ai.InstructionId=axl.MessageId




GO
