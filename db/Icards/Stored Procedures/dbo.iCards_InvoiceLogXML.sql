SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[iCards_InvoiceLogXML]
@batchno varchar(20),
@xml text
AS

insert into InvoiceLog(BatchNo, XML)
select @batchno,@xml
GO
