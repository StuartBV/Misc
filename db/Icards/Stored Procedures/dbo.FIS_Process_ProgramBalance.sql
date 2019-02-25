SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[FIS_Process_ProgramBalance]
as

set nocount on
set dateformat dmy

begin tran 

insert into dbo.FIS_Reporting_ProgramBalance ( INSTCODE, CURRCODE, PROGRAMID,
                                                NUMACCS, ACCNO, ACCTYPE,
                                                FINAMT, BLKAMT, AMTAVL,
                                                NUMCRDS, PAN, CARDID,
                                                [PRIMARY], CRDPRODUCT,
                                                CRDCUSTCODE, CRDSTATCODE,
                                                EXPDATE )

SELECT INSTCODE, CURRCODE, PROGRAMID,
        NUMACCS, ACCNO, ACCTYPE, FINAMT, BLKAMT, AMTAVL, NUMCRDS, PAN, CARDID,
        [PRIMARY], CRDPRODUCT, CRDCUSTCODE, CRDSTATCODE, EXPDATE 
FROM dbo.FISProgramBalanceLoad

truncate table dbo.FISProgramBalanceLoad

commit tran
GO
