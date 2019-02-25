SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[PolicyCardValueDetails]
AS
SELECT     cc.id [companyid],cc.ClaimNoPrefix + CAST(p.ICardsID AS varchar) AS iCardsID, p.InsurancePolicyNo, p.InsuranceClaimNo, p.IValRef, cu.LastName, cu.PostCode, 
                      cv.ID AS cardvalueid, cv.CardValue, CAST(ROUND(cv.CardValue, 0, 1) AS int) AS CardValuepounds, RIGHT(CAST(cv.CardValue AS varchar), 2) 
                      AS CardValuepence, systype.Description AS TransType, cv.Description, cv.Status, cv.AuthRequirement, cv.AuthBy, cv.AuthDate, p.wizardstage, 
                      cd.CardType, cd.ID, cv.batchfileuploaded
FROM         dbo.Card_companies cc LEFT OUTER JOIN
                      dbo.policies p ON cc.ID = p.CompanyID LEFT OUTER JOIN
                      dbo.Customers cu ON cu.iCardsID = p.ICardsID LEFT OUTER JOIN
                      dbo.Cards cd ON cd.CustomerId = cu.ID LEFT OUTER JOIN
                      dbo.Transactions cv ON cv.CardID = cd.ID LEFT OUTER JOIN
                      dbo.SysLookup sys ON sys.Code = cd.CardType AND sys.TableName = 'CardType' LEFT OUTER JOIN
                      dbo.SysLookup systype ON systype.Code = cv.Type AND systype.TableName = 'CardActionType'


GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
               Right = 397
            End
            DisplayFlags = 280
            TopColumn = 14
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
            TopColumn = 0
         End
         Begin Table = "sys"
            Begin Extent = 
               Top = 246
               Left = 241
               Bottom = 361
               Right = 401
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "systype"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 481
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
   ', 'SCHEMA', N'dbo', 'VIEW', N'PolicyCardValueDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'      End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
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
', 'SCHEMA', N'dbo', 'VIEW', N'PolicyCardValueDetails', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'PolicyCardValueDetails', NULL, NULL
GO
