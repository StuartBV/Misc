SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClaimPayments]
@id INT
AS

SET NOCOUNT ON
SET DATEFORMAT DMY
Set transaction isolation level read uncommitted

begin

create table ##payments(
	tabindex int identity(1,1),
	ID int,
	ClaimID int,
	TransDate datetime,
	ChequeNo varchar(20),
	Payee varchar(50),
	description varchar(50),
	[Type] varchar(20),
	Amount money,
	Expensecode varchar(500),
	[Status] varchar(500),
	DateAuthorised datetime,
	DatePaid datetime,
	DateCancelled datetime,
	DateDeclined datetime,
	PaymentServiceGuid varchar(100),
	ClientRefNo varchar(50),
	PolicyNo varchar(50),
	Client varchar(200)
)

insert into ##payments ( ID,ClaimID,TransDate,ChequeNo,Payee,description,Type,Amount,
						Expensecode,Status,DateAuthorised,DatePaid,DateCancelled,DateDeclined,
						PaymentServiceGuid,ClientRefNo,PolicyNo,Client)

select cp.ID,
	cp.ClaimID,
	cp.TransDate,
	cp.ChequeNo,
	cp.Payee,
	coalesce(s3.Description,cp.Description) description,
	cp.[Type],
	cp.Amount,
	s1.Description Expensecode,
	s2.Description [Status],
	cp.DateAuthorised,
	cp.DatePaid,
	cp.DateCancelled,
	cp.DateDeclined,
	cp.PaymentServiceGuid,
	c.ClientRefNo,
	p.PolicyNo,
	p.Client
FROM fnol_claimPayments cp 
join fnol_claims c on cp.ClaimID = c.ClaimID
join dbo.FNOL_Policy p on p.id=c.PolicyID
LEFT JOIN syslookup s1 ON cp.Expensecode=s1.Code AND s1.TableName='fnol - limittype'
LEFT JOIN syslookup s2 ON cp.status=s2.Code AND s2.TableName='fnol - paycode'
left join syslookup s3 on s3.tablename='FNOL - PaymentsDescription' and s3.code=cp.Description
WHERE cp.claimId=@id


SELECT * FROM ##payments

drop table ##payments

END

Set transaction isolation level read committed

GO
