/*
   martes, 16 de julio de 201311:54:36
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
CREATE TABLE dbo.Tmp_userverification
	(
	UserID int NOT NULL,
	VerificationID int NOT NULL,
	PositionID int NOT NULL,
	DateVerified datetime NOT NULL,
	CreatedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	VerifiedBy varchar(25) NOT NULL,
	LastVerifiedDate datetime NOT NULL,
	Active bit NOT NULL,
	VerificationStatusID int NOT NULL,
	Comments varchar(2000) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_userverification SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_userverification ADD CONSTRAINT
	DF_userverification_PositionID DEFAULT 0 FOR PositionID
GO
IF EXISTS(SELECT * FROM dbo.userverification)
	 EXEC('INSERT INTO dbo.Tmp_userverification (UserID, VerificationID, DateVerified, CreatedDate, UpdatedDate, VerifiedBy, LastVerifiedDate, Active, VerificationStatusID, Comments)
		SELECT UserID, VerificationID, DateVerified, CreatedDate, UpdatedDate, VerifiedBy, LastVerifiedDate, Active, VerificationStatusID, Comments FROM dbo.userverification WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.userverification
GO
EXECUTE sp_rename N'dbo.Tmp_userverification', N'userverification', 'OBJECT' 
GO
ALTER TABLE dbo.userverification ADD CONSTRAINT
	PK_userverification PRIMARY KEY CLUSTERED 
	(
	UserID,
	VerificationID,
	PositionID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.userverification', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.userverification', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.userverification', 'Object', 'CONTROL') as Contr_Per 