/*
   martes, 24 de mayo de 201620:43:03
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
CREATE TABLE dbo.Tmp_address
	(
	AddressID int NOT NULL IDENTITY (1, 1),
	UserID int NOT NULL,
	AddressTypeID int NOT NULL,
	AddressName varchar(50) NOT NULL,
	AddressLine1 varchar(100) NOT NULL,
	AddressLine2 varchar(100) NULL,
	City varchar(100) NOT NULL,
	StateProvinceID int NOT NULL,
	PostalCodeID int NOT NULL,
	CountryID int NOT NULL,
	Latitude float(53) NULL,
	Longitude float(53) NULL,
	GoogleMapsURL varchar(2073) NULL,
	SpecialInstructions varchar(1000) NULL,
	CreatedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	ModifiedBy varchar(25) NOT NULL,
	Active bit NULL,
	CreatedBy int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_address SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_address ON
GO
IF EXISTS(SELECT * FROM dbo.address)
	 EXEC('INSERT INTO dbo.Tmp_address (AddressID, UserID, AddressTypeID, AddressName, AddressLine1, AddressLine2, City, StateProvinceID, PostalCodeID, CountryID, Latitude, Longitude, GoogleMapsURL, SpecialInstructions, CreatedDate, UpdatedDate, ModifiedBy, Active, CreatedBy)
		SELECT AddressID, UserID, AddressTypeID, AddressName, AddressLine1, AddressLine2, City, StateProvinceID, PostalCodeID, CountryID, Latitude, Longitude, GoogleMapsURL, SpecialInstructions, CreatedDate, UpdatedDate, ModifiedBy, Active, CreatedBy FROM dbo.address WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_address OFF
GO
ALTER TABLE dbo.booking
	DROP CONSTRAINT FK__booking__serviceAddress
GO
DROP TABLE dbo.address
GO
EXECUTE sp_rename N'dbo.Tmp_address', N'address', 'OBJECT' 
GO
ALTER TABLE dbo.address ADD CONSTRAINT
	PK_address_1 PRIMARY KEY CLUSTERED 
	(
	AddressID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.address', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.address', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.address', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.booking ADD CONSTRAINT
	FK__booking__serviceAddress FOREIGN KEY
	(
	ServiceAddressID
	) REFERENCES dbo.address
	(
	AddressID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.booking SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.booking', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.booking', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.booking', 'Object', 'CONTROL') as Contr_Per 