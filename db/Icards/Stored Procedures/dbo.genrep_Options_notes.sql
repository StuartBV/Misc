SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[genrep_Options_notes]
@from varchar(10),
@to varchar(10)
AS
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

SELECT n.iCardsID optionsRef,
	   n.Note,
	   ISNULL(convert(char(10),n.CreateDate,103)+' '+convert(char(5),n.CreateDate,14),'') createdate,
	   ISNULL(n.CreatedBy,'') createdby,
	   ISNULL(convert(char(10),n.altereddate,103)+' '+convert(char(5),n.altereddate,14),'') altereddate,
	   ISNULL(n.AlteredBy,'') altetredby,
	   ISNULL(s1.Description,'') notetype,
	   ISNULL(s2.Description,'') NoteReason 
FROM notes n  
LEFT JOIN SysLookup s1 ON n.NoteType=s1.code AND s1.tablename='notetype'
LEFT JOIN SysLookup s2 ON n.NoteReason=s2.code AND s2.tablename='notereason'
WHERE n.CreateDate BETWEEN @fd AND @td

set transaction isolation level read committed


GO
