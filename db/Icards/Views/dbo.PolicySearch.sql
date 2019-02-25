SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[PolicySearch] as
select 'SEARCH' as results, cc.id [companyid],cc.ClaimNoPrefix + cast(p.ICardsID as varchar) as iCardsID, p.[Status], p.InsurancePolicyNo, p.InsuranceClaimNo, p.IValRef, 
cu.LastName, cu.PostCode, convert(char(10), p.CreateDate, 103) + ' ' + convert(char(5), p.CreateDate, 14) as CreateDate, 
sys.[Description] as CardType, p.wizardstage, wiz.[Description] as stage, cd.ID as cardid, convert(char(8), p.AlteredDate, 8) as [time], 
coalesce (e.FName + ' ' + e.SName, 'Administrator') as empname, p.ICardsID as seq, p.AlteredBy,
convert(char(10), p.AlteredDate, 103) + ' ' + convert(char(5), p.AlteredDate, 14) as AlteredDate, p.cancelreason
from Card_companies as cc inner join policies as p on cc.ID = p.CompanyID
join Customers as cu on cu.iCardsID = p.ICardsID
join Cards as cd on cd.CustomerId = cu.ID
left join SysLookup as sys on sys.Code = cd.CardType and sys.TableName = 'CardType'
left join PPD3.dbo.Logon as l on p.AlteredBy = l.UserID
left join PPD3.dbo.employees as e on e.Id = l.UserFK
left join dbo.SysLookup as wiz on wiz.Code = p.wizardstage and wiz.TableName = 'wizardstage'



GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[15] 2[20] 3) )"
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
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 17
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
         Begin Table = "sys"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 246
               Left = 236
               Bottom = 361
               Right = 421
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 481
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         E', 'SCHEMA', N'dbo', 'VIEW', N'PolicySearch', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'nd
         Begin Table = "wiz"
            Begin Extent = 
               Top = 6
               Left = 418
               Bottom = 121
               Right = 578
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', 'SCHEMA', N'dbo', 'VIEW', N'PolicySearch', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'PolicySearch', NULL, NULL
GO
