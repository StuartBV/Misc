CREATE TABLE [dbo].[FNOL_ClaimPayments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[TransDate] [datetime] NULL,
[ChequeNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payee] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutstandingEstimate] [money] NULL,
[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[Expensecode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatePaid] [datetime] NULL,
[DateAuthorised] [datetime] NULL,
[DateCancelled] [datetime] NULL,
[DateDeclined] [datetime] NULL,
[PaymentServiceGuid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[StatusChange] ON [dbo].[FNOL_ClaimPayments] 
FOR INSERT,UPDATE
AS
declare
@status varchar(10),
@statustext varchar(50),
@sql varchar(1000)

set nocount on

if update(status)
begin

	select @status=i.status, @statustext=s.Description 
	from inserted i 
	join syslookup s on s.TableName='FNOL - PayCode' and i.status=s.code

	insert into FNOL_Notes (ClaimID,Note,Createdate,createdby,NoteType, NoteReason) 
	select claimID, case when status='REC' then 'Payment Recomended by '+createdby
	else 'Payment status changed to '+@statustext+' by '+alteredby end,
	getdate(),'System',100,7
	from inserted
			
	if @status='AUTH'
	 begin
		update cp 
		set cp.dateauthorised=getdate(),cp.AlteredBy=i.alteredby,cp.AlteredDate=getdate()
		from FNOL_ClaimPayments cp with (nolock) 
		join inserted i on cp.ID=i.id
	 end
	 
	if @status='PAID'
	 begin
		update cp 
		set cp.datepaid=getdate(),cp.AlteredBy=i.alteredby,cp.AlteredDate=getdate()
		from FNOL_ClaimPayments cp with (nolock) 
		join inserted i on cp.ID=i.id
	 end
	 
	if @status='CAN'
	 begin
		update cp 
		set cp.datecancelled=getdate(),cp.AlteredBy=i.alteredby,cp.AlteredDate=getdate()
		from FNOL_ClaimPayments cp with (nolock) 
		join inserted i on cp.ID=i.id
	 end
	 
	if @status='DEC'
	 begin
		update cp 
		set cp.datedeclined=getdate(),cp.AlteredBy=i.alteredby,cp.AlteredDate=getdate()
		from FNOL_ClaimPayments cp with (nolock) 
		join inserted i on cp.ID=i.id
	 end

end
GO
ALTER TABLE [dbo].[FNOL_ClaimPayments] ADD CONSTRAINT [PK_FNOL_ClaimPayments] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimid] ON [dbo].[FNOL_ClaimPayments] ([ClaimID], [TransDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_paymentserviceguid] ON [dbo].[FNOL_ClaimPayments] ([PaymentServiceGuid]) ON [PRIMARY]
GO
