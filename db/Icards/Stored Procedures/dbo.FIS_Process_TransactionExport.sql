SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[FIS_Process_TransactionExport]
as

set nocount on
set dateformat ymd

begin tran 

insert into dbo.FIS_Reporting_TransactionExport ( 
	TransType, Mtid, Localdate,Localtime, Tlogid, Itemid,OrgItemid, Msgid, Pan,
    Cardid, Crdproduct,Programid, Brncode, Txncode,Txnsubcode, Billamt,
    Curbill, Acccur, Accno,Acctype, Billconvrate,Amtpad, Amtcom, Curtxn,
    Amttxn, Amttxncb,Approvalcode, Cortexdate,Stan, Rrn, Termcode,
    Crdacptid, Termlocation,Termstreet, Termcity,Termcountry, [Schema], Chic,
    Chac, Chp, Cp, Cdim, Cham,Cha, Msgsrc, Rcc, Mcc,Actioncode, Rspcode, Tvr,
    Rev, Extcode, Txndate,Txntime, Termtype,Ctxdatelocal, Ctxtimelocal,Firstname, lastname, Aiid 
    )

SELECT TransType, Mtid, 
		case when Localdate='' then null else cast(replace(Localdate,'-','') as datetime) end,
       case when Localtime='' then '' 
       else left(Localtime,2)+':'+substring(Localtime,2,2)+':'+right(Localtime,2)
       end, 
       Tlogid, Itemid,OrgItemid, Msgid, Pan,Cardid, Crdproduct,Programid, Brncode, Txncode,Txnsubcode, 
       case when Billamt='' then null else
		case when TransType in ('AUTHADV','FINADV') then cast('-'+Billamt as money) else cast(Billamt as money) end
		end,
       Curbill, Acccur, Accno,Acctype, Billconvrate,Amtpad, Amtcom,Curtxn,
       case when Amttxn='' then null else
		case when TransType in ('AUTHADV','FINADV') then cast('-'+Amttxn as money) else cast(Amttxn as money) end
		end,       
       Amttxncb,Approvalcode, 
       case when Cortexdate='' then null else cast(replace(Cortexdate,'-','') as datetime) end,
       Stan, Rrn, Termcode,Crdacptid, Termlocation,Termstreet, Termcity,Termcountry, [Schema], Chic,
       Chac, Chp, Cp, Cdim, Cham,Cha, Msgsrc, Rcc, Mcc,Actioncode, Rspcode, Tvr,Rev, Extcode, 
       case when Txndate='' then null else cast(replace(Txndate,'-','') as datetime) end,
       Txntime, Termtype,
       case when Ctxdatelocal='' then null else cast(replace(Ctxdatelocal,'-','') as datetime) end, 
       case when Ctxtimelocal='' then ''
       else left(Ctxtimelocal,2)+':'+substring(Ctxtimelocal,2,2)+':'+right(Ctxtimelocal,2)
       end,
       Firstname, lastname, Aiid 
FROM dbo.FISTransactionExportLoad

truncate table dbo.FISTransactionExportLoad

commit tran
GO
