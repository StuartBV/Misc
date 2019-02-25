SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[FIS_Process_AccountException]
as

set nocount on
set dateformat dmy

begin tran 

insert into dbo.FIS_Reporting_AccountException ( 
	EXCEPTTYPE, PAN, CRDEXPDATE,ITEMID, TLOGID, AMTBILL,
    CURBILLALPHA, DATELOCAL,APRVLCODE, RRN, ACCNO,
    CUSTCODE, AVLBAL, BLKAMT,ORIGLOADAMT, MAXBAL,INSTCODE )
    
SELECT EXCEPTTYPE, PAN, CRDEXPDATE, ITEMID,
        TLOGID, AMTBILL, CURBILLALPHA, DATELOCAL, APRVLCODE, RRN, ACCNO,
        CUSTCODE, AVLBAL, BLKAMT, ORIGLOADAMT, MAXBAL, INSTCODE 
FROM dbo.FISAccountExceptionLoad

truncate table dbo.FISAccountExceptionLoad

commit tran
GO
