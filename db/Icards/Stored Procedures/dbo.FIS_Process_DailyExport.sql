SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[FIS_Process_DailyExport]
as

set nocount on
set dateformat dmy

begin tran 

insert into dbo.FIS_Reporting_DailyExport ( RECTYPE, LOCALDATE, LOCALTIME, ITEMID,
                                             MSGID, INSTCODE, PAN, CARDID,
                                             CRDPRODUCT, PROGRAMID, BRNCODE,
                                             CURBILL, ACCCUR, ACCNO, ACCTYPE,
                                             AMTBILL, CORTEXDATE, CRDACPTID,
                                             REV, ORGITEMID, DESCRIPTION,
                                             LOADSRC, LOADTYPE, TOTITEMS )

SELECT RECTYPE, LOCALDATE, LOCALTIME,
        ITEMID, MSGID, INSTCODE, PAN, CARDID, CRDPRODUCT, PROGRAMID, BRNCODE,
        CURBILL, ACCCUR, ACCNO, ACCTYPE, cast(AMTBILL as money), CORTEXDATE, CRDACPTID, REV,
        ORGITEMID, DESCRIPTION, LOADSRC, LOADTYPE, TOTITEMS 
FROM dbo.FISDailyExportLoad


truncate table dbo.FISDailyExportLoad

commit tran
GO
