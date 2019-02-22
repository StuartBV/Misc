SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Data_Standing_LastMsgXS] as
SELECT     x.sourcekey, x.SupplierID, x.MessageType, CASE WHEN ds.Excess > 0 THEN 1 ELSE 0 END HasExcess
FROM         Data_Standing_MaxMessageID x JOIN
                      data_standing ds ON ds.MessageID = x.messageID
-- ENSURE there has not been a CANCELLATION message for supplier (usually powerplay) if so, all previous rows are to be ignored
where not exists (select * from data_standing z where z.EventType=1 and z.sourcekey=x.sourcekey and x.supplierID=z.supplierID)
GO
