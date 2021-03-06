SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[FIS_Process_CardExt]
as

set nocount on
set dateformat dmy

begin tran 

insert into dbo.FIS_Reporting_CardExt ( RECID, PAN, PREVPAN, ACCNO, ACCTYPE,
                                  OLDSTATCODE, STATCODE, TITLE, LASTNAME,
                                  FIRSTNAME, DESIGNREF, IMAGEID, DLVMETHOD,
                                  ISOLANG, CARDID, PREVCARDID, BRNCODE, [USER],
                                  USERGRP, CARDEVENT, EXPDATE, PROGRAMID,
                                  PARTICIPANTID, ACCOUNTID, CRDBTCHNO,
                                  CUSTCODE, CRDPRODUCT, ACCESSCODE, CARRIERPAN,
                                  STOCKNO, FUNDCRDPAN, FUNDCRDEFFDATE,
                                  FUNDCRDEXPDATE, FUNDCRDTYPE, FUNDCRDISSNUM,
                                  ADDRIND, ADDRL1, ADDRL2, ADDRL3, CITY,
                                  COUNTY, POSTCODE, COUNTRY, WORKADDRL1,
                                  WORKADDRL2, WORKADDRL3, WORKCITY, WORKCOUNTY,
                                  WORKPOSTCODE, WORKCOUNTRY, POBOX, DLVADDRL1,
                                  DLVADDRL2, DLVADDRL3, DLVCITY, DLVCOUNTY,
                                  DLVPOSTCODE, DLVCOUNTRY, DLVINDATE,
                                  DLVPURGEDATE, TOTALCARDS, TOTALRENCARDS,
                                  TOTALREPCARDS, TOTALREISSCARDS, TOTALPINS,
                                  TOTALPINREP, TOTALPINRMND, TOTALSTATCHG,
                                  TOTALTOEXPIRE )

SELECT RECID, PAN, PREVPAN, ACCNO, ACCTYPE,
        OLDSTATCODE, STATCODE, TITLE, LASTNAME, FIRSTNAME, DESIGNREF, IMAGEID,
        DLVMETHOD, ISOLANG, CARDID, PREVCARDID, BRNCODE, [USER], USERGRP,
        CARDEVENT, EXPDATE, PROGRAMID, PARTICIPANTID, ACCOUNTID, CRDBTCHNO,
        CUSTCODE, CRDPRODUCT, ACCESSCODE, CARRIERPAN, STOCKNO, FUNDCRDPAN,
        FUNDCRDEFFDATE, FUNDCRDEXPDATE, FUNDCRDTYPE, FUNDCRDISSNUM, ADDRIND,
        ADDRL1, ADDRL2, ADDRL3, CITY, COUNTY, POSTCODE, COUNTRY, WORKADDRL1,
        WORKADDRL2, WORKADDRL3, WORKCITY, WORKCOUNTY, WORKPOSTCODE,
        WORKCOUNTRY, POBOX, DLVADDRL1, DLVADDRL2, DLVADDRL3, DLVCITY,
        DLVCOUNTY, DLVPOSTCODE, DLVCOUNTRY, DLVINDATE, DLVPURGEDATE,
        TOTALCARDS, TOTALRENCARDS, TOTALREPCARDS, TOTALREISSCARDS, TOTALPINS,
        TOTALPINREP, TOTALPINRMND, TOTALSTATCHG, TOTALTOEXPIRE 
FROM dbo.FISCardExtLoad

truncate table dbo.FISCardExtLoad

commit tran
GO
