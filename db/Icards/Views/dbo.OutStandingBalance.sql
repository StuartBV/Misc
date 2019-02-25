SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[OutStandingBalance]
AS
SELECT		p.InsuranceClaimNo [Aviva Claim Ref], 
			p.ICardsID, 
			cv.CardValue,
			ISNULL(cu.Title,icc.Title) + ' ' + ISNULL(cu.FirstName,icc.FirstName) + ' ' + ISNULL(cu.LastName,icc.LastName) [Customer],
			ISNULL(cu.Address1,icc.Address1) + ', ' + ISNULL(cu.Address2,icc.Address2) + ', ' + ISNULL(cu.Town,icc.Town) + ', ' + ISNULL(cu.County,icc.County) + ', ' + ISNULL(cu.PostCode,icc.PostCode) [Address],
			 CAST(ISNULL(cu.Phone,icc.Phone) AS varchar) AS [Contact Details],
			 			icc.Title + ' ' + icc.FirstName + ' ' + icc.LastName + ' ' +
			icc.Address1 + ', ' + icc.Address2 + ', ' + icc.Town + ', ' + icc.County + ', ' + icc.PostCode + ' ' +
			 CAST(icc.Phone AS varchar) AS [Archived Customer Details]
FROM        dbo.Card_companies cc 
			LEFT OUTER JOIN dbo.policies p ON cc.ID = p.CompanyID AND p.CancelReason IS NULL AND p.CompanyID = 2
			LEFT OUTER JOIN dbo.Customers cu ON cu.iCardsID = p.ICardsID
			LEFT OUTER JOIN dbo.Cards cd ON cd.CustomerId = cu.ID 
			JOIN dbo.CardValue cv ON cd.id = cv.cardid AND cv.CardValue > 0.01
			LEFT JOIN PPD3Archive..icards_Customers icc ON p.ICardsID = icc.iCardsID
GO
