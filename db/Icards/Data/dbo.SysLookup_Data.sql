SET IDENTITY_INSERT [dbo].[SysLookup] ON
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (1, 'CardType', '1', 'Aviva', '1000000000000100220', '01', 'NUD')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (2, 'CardType', '2', 'Aviva', '1000000000000100221', '02', 'NUIB')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (3, 'CardType', '3', 'iVal', '1000000000000100222', '03', 'IVAL')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (4, 'CardType', '4', 'iVal Jewellery', '1000000000000100223', '04', 'JEWELLERY')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (5, 'LogType', '1', 'iVal clearup Process', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (6, 'LogType', '2', 'New Policy', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (7, 'LogType', '20', 'Card - Add Value', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (8, 'CardActionType', 'A', 'Add Member', NULL, NULL, 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (9, 'CardActionType', 'B', 'Balance Adjustment', NULL, 'Add/Subtract Value', 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (10, 'CardActionType', 'V', 'Activate Card', NULL, NULL, 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (11, 'CardActionType', 'M', 'Combo Add Member / Balance Adjustment', NULL, 'New Card and Add Value', 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (12, 'CardActionType', 'L', 'Block Member', NULL, NULL, 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (13, 'CardActionType', 'R', 'Reissue - Damaged Card', NULL, 'Reissue Card', 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (14, 'CardActionType', 'X', 'Close', NULL, NULL, 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (15, 'CardActionType', 'C', 'Change User Profile', NULL, NULL, 'Load')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (16, 'InvoiceBatchNo', '64', '', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (17, 'CardTransactionStatus', '0', 'In Progress', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (18, 'CardTransactionStatus', '1', 'Processing', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (19, 'CardTransactionStatus', '2', 'Complete', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (20, 'CardTransactionStatus', '-1', 'Process Error', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (21, 'CardTransactionAuthorisation', '0', 'None required', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (22, 'CardTransactionAuthorisation', '1', 'Level 1 Auth Reqd', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (23, 'CardTransactionAuthorisation', '2', 'Level 2 Auth Reqd', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (24, 'CardTransactionAuthorisation', '-1', 'Authorisation Rejected', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (25, 'LogType', '21', 'Card - Add Value & Reissue', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (26, 'LogType', '22', 'Card - Re-Issue', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (28, 'NoteType', '1', 'User Note', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (29, 'NoteReason', '0', 'Other', NULL, '0', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (30, 'NoteReason', '1', 'In - Customer', NULL, '0', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (31, 'NoteReason', '2', 'In - Insurance Company', NULL, '0', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (32, 'NoteReason', '3', 'Outbound - Customer', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (33, 'NoteReason', '4', 'Outbound - Insurance Company', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (34, 'LogType', '6', 'Create Note', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (35, 'LogType', '7', 'Edit Note', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (36, 'LogType', '8', 'Delete Note', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (37, 'CardActionType', 'Z', 'Reported Lost/Stolen', NULL, 'Reported Lost/Stolen', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (38, 'CardTransactionStatus', '10', 'Never Batch File', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (39, 'DisputeReason', '1', 'Transaction Not Known', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (40, 'DisputeReason', '2', 'Value Incorrect', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (41, 'CardTransactionAuthorisation', '3', 'Level 3 Auth Reqd', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (42, 'AdminMenu', 'batch', 'Create Batch Files', '1', 'ixxx', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (43, 'AdminMenu', 'auth2', 'Authorise Level 2 (Over £10,000)', '3', 'i', '4')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (44, 'AdminMenu', 'audit', 'Authorise Level 3 (Audit Checking)', '4', 'i', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (46, 'AdminMenu', 'auth1', 'Authorise Level 1 (£2,500 - £10,000)', '2', 'i', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (47, 'wizardstage', '1', 'Initial Creation Stage', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (48, 'wizardstage', '2', 'Duplicates being Resolved', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (49, 'wizardstage', '3', 'Finalisation Stage', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (50, 'wizardstage', '4', 'Completed', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (51, 'AdminMenu', 'redem', 'Awaiting Redemption', '5', 'i', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (52, 'NoteType', '30', 'Auto Note: callback System', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (53, 'LogType', '10', 'Reminders', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (54, 'wizardstage', '0', 'Cancelled', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (55, 'CancelReason', '0', 'Unknown', NULL, '0', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (58, 'CancelReason', '1', 'Withdrawn by customer', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (62, 'CancelReason', '5', 'Card Redeemed', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (68, 'CancelReason', '2', 'Withdrawn by NU', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (72, 'CancelReason', '3', 'Fraudulent Request', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (75, 'CancelReason', '4', 'Duplicate', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (76, NULL, NULL, NULL, NULL, NULL, 'select * from claims#')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (77, 'BatchFileErrors', '1', 'Can''t re-issue an unblocked card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (78, 'BatchFileErrors', '2', 'Card does not exist', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (79, 'BatchFileErrors', '3', 'External Key not recognised', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (80, 'LogType', '100', 'Supervisor Override', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (81, 'LogType', '9', 'Edit PH Details', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (82, 'LogType', '23', 'Card - Deduct Value', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (83, 'LogType', '24', 'Card - Reported Lost/Stolen', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (84, 'LogType', '25', 'Card - Disputed Transaction', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (85, 'LogType', '26', 'Card - Redemption', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (86, 'LogType', '30', 'Batch File Process', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (87, 'CancelReason', '6', 'Withdrawn by Goldsmiths', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (88, 'BatchFileErrors', '5', 'TSYS System Error', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (89, 'NoteReason', '100', 'In-Customer-Card not received', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (90, 'NoteReason', '101', 'In-Customer-Wrong name on Card', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (91, 'NoteReason', '102', 'In-Customer-Activation Issue', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (92, 'NoteReason', '103', 'In-Customer-Retailer Issue', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (93, 'NoteReason', '104', 'In-Customer-Transaction Query', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (94, 'NoteReason', '105', 'In-Customer-Balance Request', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (95, 'NoteReason', '106', 'In-Customer-Redemption', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (96, 'NoteReason', '107', 'In-Customer-Other', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (97, 'NoteReason', '200', 'In-Ins Co-Card not received', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (98, 'NoteReason', '201', 'In-Ins Co-Wrong name on card', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (99, 'NoteReason', '202', 'In-Ins Co-Activation Issue', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (100, 'NoteReason', '203', 'In-Ins Co-Retailer Issue', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (101, 'NoteReason', '204', 'In-Ins Co-Transaction Query', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (102, 'NoteReason', '205', 'In-Ins Co-Balance Request', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (103, 'NoteReason', '206', 'In-Ins Co-Redemption', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (104, 'NoteReason', '207', 'In-Ins Co-Other', NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (105, 'LogType', '50', 'Cancel Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (106, 'LogType', '51', 'UnCancel Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (107, 'AdminMenu', 'reward', 'Reward Cards', '6', 'ixxx', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (108, 'CardType', '5', 'Aviva Reward', '1000000000000130330', '05', 'REWARD')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (109, 'ServerName', NULL, 'DEV', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (110, 'PC_LoopTypes', 'C', 'Closed Loop Card', NULL, 'Pure', '/ICE/images/logos/Pure_logo_CLOSED_Green.gif')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (111, 'PC_LoopTypes', 'O', 'Open Loop Card', NULL, 'Pure World', '/ICE/images/logos/Pure_logo_OPEN_Silver.gif')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (112, 'PC_CardTypes', '0', 'Magstripe/Prepay Visa', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (113, 'PC_CardTypes', '1', 'Chip & Pin', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (114, 'PC_POStatus', '10', 'Created', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (115, 'PC_POStatus', '20', 'Uploaded', NULL, NULL, 'Awaiting Order Confirmation')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (116, 'PC_POStatus', '30', 'Uploaded', NULL, NULL, 'Order Confirmed, Awaiting Card Numbers')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (117, 'PC_POStatus', '40', 'Uploaded', NULL, NULL, 'Card Numbers Received')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (118, 'PC_POStatus', '100', 'Received', NULL, NULL, 'Cards Received in Building')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (119, 'PC_POStatus', '-1', 'Failed', NULL, NULL, 'PO Order Failed')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (120, 'PC_POStatus', '99', 'Cancelled', NULL, NULL, 'Order Cancelled by Powerplay')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (121, 'PC_POUpload', NULL, NULL, '0', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (122, 'Logtype', '200', 'PureCard Upload Process', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (123, 'PC_TextAlerts', '0', 'Alison Grant', '1', NULL, '447921476774')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (124, 'PC_TextAlerts', '0', 'Jason Morrison', '1', NULL, '447733224946')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (125, 'PC_TextAlerts', '0', 'Mark Harrison', '1', NULL, '447751235043')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (126, 'PC_VirtualAccountBalance', NULL, NULL, '10.00', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (127, 'Logtype', '201', 'PureCard Balance Check', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (128, 'PC_VA_LowLimit', NULL, NULL, '10000', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (129, 'PC_ShipRequestStatus', '0', 'Awaiting Processing', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (130, 'PC_ShipRequestStatus', '-1', 'Cancelled', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (131, 'PureCard_DateAdd', '1', 'Pushes dates forward if time is greater than 3pm when requesting a card', '1', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (132, 'PureCard_DateAdd', '2', 'Pushes dates forward if no stock of card and validity being requested', '5', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (133, 'PureCard_DateAdd', '3', 'Pushes dates forward if card value exceeds Virtual Balance (AM Balance - Queued cards SUM )', '3', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (134, 'PC_ShipRequestStatus', '10', 'Processed', NULL, NULL, 'Awaiting Collateral to be printed')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (135, 'PC_ShipRequestStatus', '20', 'Processed', NULL, NULL, 'Awaiting upload')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (136, 'PC_ShipRequestStatus', '30', 'Uploaded', NULL, NULL, 'Awaiting confirmation')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (137, 'PC_OrderUpload_Running', NULL, NULL, '0', NULL, 'When flags=1 then running')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (138, 'PC_ShipRequestStatus', '40', 'Uploaded', NULL, NULL, 'Confirmed')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (139, 'PC_ShipRequestStatus', '-2', 'Failed', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (140, 'PC_ShipRequestStatus', '50', 'Blocked', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (141, 'OptionsCardRestrictedSupplier', '6261', 'Restricts product values on card to be spent at products suppliers stores', NULL, 'ARGOS001', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (142, 'FISDailySequence', '8', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (143, 'CardType', '6', 'FIS Card', '1000000000000000000', '06', 'Options')
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (144, 'FisStatusCode', '00', 'Normal', 'Approve', '000', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (145, 'FisStatusCode', '01', 'PIN Tries Exceeded', 'Deny', '106', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (146, 'FisStatusCode', '02', 'Inactive', 'Deny', '125', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (147, 'FisStatusCode', '03', 'Card Expired', 'Deny', '101', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (148, 'FisStatusCode', '04', 'Lost', 'Deny & Pick up card', '208', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (149, 'FisStatusCode', '05', 'Stolen', 'Deny & Pick up card', '209', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (150, 'FisStatusCode', '06', 'Cardholder Closed', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (151, 'FisStatusCode', '07', 'Issuer Cancelled', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (152, 'FisStatusCode', '08', 'Fraudulent Use', 'Deny & Pick up card', '202', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (153, 'FisStatusCode', '09', 'Dormant', 'Deny', '125', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (154, 'FisStatusCode', '10', 'Pending Breakage', 'Deny & Pick up card', '200', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (155, 'FisStatusCode', '11', 'Pending Closure', 'Deny', '125', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (156, 'FisStatusCode', '60', 'Suspend', 'Deny', '107', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (157, 'FisStatusCode', '61', 'Card Returned', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (158, 'FisStatusCode', '62', 'Watch', 'Approve', '000', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (159, 'FisStatusCode', '63', 'Other Returned', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (160, 'FisStatusCode', '64', 'Fraud', 'Deny & Pick up card', '202', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (161, 'FisStatusCode', '65', 'Bankrupt', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (162, 'FisStatusCode', '66', 'Cancelled', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (163, 'FisStatusCode', '67', 'No Renewal', 'Approve', '000', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (164, 'FisStatusCode', '68', 'Deceased', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (165, 'FisStatusCode', '77', 'Block', 'Deny', '100', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (166, 'FisStatusCode', '78', 'Refer to Issuer', 'Deny', '107', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (167, 'FisStatusCode', '84', 'Delinquent', 'Deny', '116', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (168, 'FisStatusCode', '86', 'Restricted Card', 'Deny', '104', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (169, 'FisStatusCode', '89', 'Pick Up', 'Deny & Pick up card', '200', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (170, 'FisCardEvent', '1', 'New Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (171, 'FisCardEvent', '2', 'Renewed Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (172, 'FisCardEvent', '3', 'Replacement Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (173, 'FisCardEvent', '4', 'Re-issued Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (174, 'FisCardEvent', '5', 'New PIN', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (175, 'FisCardEvent', '6', 'PIN Replacement', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (176, 'FisCardEvent', '7', 'Card Status change', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (177, 'FisCardEvent', '8', 'Card Expiry Due', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (178, 'FisCardEvent', '9', 'PIN Reminder', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (179, 'FISActionCode', '1', 'New Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (180, 'FISActionCode', '2', 'Load/ReLoad', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (181, 'FISActionCode', '3', 'Replace Lost/Stolen', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (182, 'FISActionCode', '4', 'Replace Damaged Card', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (183, 'FISActionCode', '6', 'Ammend Card Details', NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (184, 'FISActionCodeMapping', 'M', NULL, NULL, '1', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (185, 'FISActionCodeMapping', 'B', NULL, NULL, '2', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (186, 'FISActionCodeMapping', 'Z', NULL, NULL, '3', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (187, 'FISActionCodeMapping', 'R', NULL, NULL, '4', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (188, 'FISActionCodeMapping', 'C', NULL, NULL, '6', NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (189, 'OptionsCardTypes', '8', 'FIS Card', '6', NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (190, 'FISDailyRequestSequence', '31', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (191, 'FISDailyAdjustmentSequence', '23', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (192, 'FISMessageID', '63', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[SysLookup] ([ID], [TableName], [Code], [Description], [Flags], [ExtraCode], [ExtraDescription]) VALUES (193, 'NoteReason', '250', 'In-Customer-Dissatisfaction', NULL, '1', NULL)
SET IDENTITY_INSERT [dbo].[SysLookup] OFF
