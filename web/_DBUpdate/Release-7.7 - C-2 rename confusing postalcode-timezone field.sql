/*
   lunes, 28 de noviembre de 201620:52:55
   User: 
   Server: localhost\SQLEXPRESS
   Database: loconomics
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
EXECUTE sp_rename N'dbo.postalcode.TimeZone', N'Tmp_StandardOffset', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.postalcode.Tmp_StandardOffset', N'StandardOffset', 'COLUMN' 
GO
ALTER TABLE dbo.postalcode SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.postalcode', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.postalcode', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.postalcode', 'Object', 'CONTROL') as Contr_Per 