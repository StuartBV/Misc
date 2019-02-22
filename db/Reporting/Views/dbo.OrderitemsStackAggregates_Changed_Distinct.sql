SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[OrderitemsStackAggregates_Changed_Distinct] AS
SELECT DISTINCT ClaimID FROM dbo.orderitemsStackAggregates_Changed 

GO
