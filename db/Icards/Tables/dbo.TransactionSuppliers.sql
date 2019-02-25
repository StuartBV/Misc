CREATE TABLE [dbo].[TransactionSuppliers]
(
[TransactionID] [int] NOT NULL,
[SupplierID] [int] NOT NULL,
[RRP] [smallmoney] NOT NULL CONSTRAINT [DF_TransactionSuppliers_RRP] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TransactionSuppliers] ADD CONSTRAINT [PK_TransactionSuppliers] PRIMARY KEY CLUSTERED  ([TransactionID], [SupplierID]) ON [PRIMARY]
GO
