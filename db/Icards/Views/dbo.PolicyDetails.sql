SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PolicyDetails]
AS
SELECT     'EDIT' AS results, cc.ClaimNoPrefix + CAST(p.ICardsID AS varchar) AS iCardsID, cc.id [companyID], cc.Company, p.InsuranceCoID, p.InsuranceClaimNo, p.SepSCode,
                      p.InsurancePolicyNo, p.OrigOffice, p.LossAdjuster, p.LARef, p.LAOffice, p.IValRef, CONVERT(char(10), p.IncidentDate, 103) AS IncidentDate, 
                      p.ContactName, p.ContactPhone, CONVERT(char(10), p.CreateDate, 103) + ' ' + CONVERT(char(5), p.CreateDate, 14) AS CreateDate, cu.ID AS customerid, 
                      cu.Title, cu.FirstName, cu.LastName, cu.Address1, cu.Address2, cu.Town, cu.County, cu.PostCode, cu.Country, cu.Phone, cd.ID AS cardid, 
                      cd.NameOnCard, sys.Description AS CardType, cd.CarrierCode, cd.CreateDate AS cardcreated, cd.pan, cd.SupplierCardId,
                      cv.ID AS cardvalueid, cv.CardValue, cv.Type, cv.Description, cv.Status, 
                      cv.AuthRequirement, cv.AuthBy, cv.AuthDate, p.wizardstage, cv.CreateDate AS transdate, cv.InvoicedDate, cv.InvoiceValue, cv.InvoiceBatchNo, 
                      cv.Incentive, cv.IncentiveRate, p.cancelreason, cv.createdby as TcreatedBy, cv.batchfileuploaded, cv.ID TransactionID,
					p.iCardsID as iCardsIDNoPrefix, p.AlteredBy [policy_alteredby], p.AlteredDate [policy_altereddate], p.status [policy_status],cv.AdjustmentReason,
					cd.Reissue
FROM         dbo.Card_companies cc LEFT OUTER JOIN
                      dbo.policies p ON cc.ID = p.CompanyID LEFT OUTER JOIN
                      dbo.Customers cu ON cu.iCardsID = p.ICardsID LEFT OUTER JOIN
                      dbo.Cards cd ON cd.CustomerId = cu.ID LEFT OUTER JOIN
                      dbo.Transactions cv ON cv.CardID = cd.ID LEFT OUTER JOIN
                      dbo.SysLookup sys ON sys.Code = cd.CardType AND sys.TableName = 'CardType'



GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[17] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "cc"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "cu"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cd"
            Begin Extent = 
               Top = 126
               Left = 228
               Bottom = 241
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cv"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table ', 'SCHEMA', N'dbo', 'VIEW', N'PolicyDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'= 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'PolicyDetails', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'PolicyDetails', NULL, NULL
GO
