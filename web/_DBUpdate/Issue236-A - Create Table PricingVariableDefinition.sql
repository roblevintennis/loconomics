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
CREATE TABLE dbo.PricingVariableDefinition
	(
	PricingVariableID int NOT NULL,
	LanguageID int NOT NULL,
	CountryID int NOT NULL,
	PositionID int NOT NULL,
	PricingTypeID int NOT NULL,
	InternalName varchar(60) NOT NULL,
	IsProviderVariable bit NOT NULL,
	IsCustomerVariable bit NOT NULL,
	DataType varchar(50) NOT NULL,
	VariableLabel nvarchar(100) NULL,
	VariableLabelPopUp nvarchar(200) NULL,
	VariableNameSingular nvarchar(60) NULL,
	VariableNamePlural nvarchar(60) NULL,
	NumberIncludedLabel nvarchar(100) NULL,
	NumberIncludedLabelPopup nvarchar(200) NULL,
	CalculateWithVariableID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PricingVariableDefinition ADD CONSTRAINT
	DF_PricingVariableDefinition_IsProviderVariable DEFAULT 0 FOR IsProviderVariable
GO
ALTER TABLE dbo.PricingVariableDefinition ADD CONSTRAINT
	DF_PricingVariableDefinition_IsCustomerVariable DEFAULT 0 FOR IsCustomerVariable
GO
ALTER TABLE dbo.PricingVariableDefinition ADD CONSTRAINT
	PK_PricingVariableDefinition PRIMARY KEY CLUSTERED 
	(
	PricingVariableID,
	LanguageID,
	CountryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PricingVariableDefinition SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'CONTROL') as Contr_Per 

GO

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
ALTER TABLE dbo.PricingVariableDefinition ADD
	CreatedDate datetime NOT NULL CONSTRAINT DF_PricingVariableDefinition_CreatedDate DEFAULT (getdate()),
	UpdatedDate datetime NOT NULL CONSTRAINT DF_PricingVariableDefinition_UpdatedDate DEFAULT (getdate()),
	ModifiedBy varchar(25) NOT NULL CONSTRAINT DF_PricingVariableDefinition_ModifiedBy DEFAULT 'sys',
	Active bit NOT NULL CONSTRAINT DF_PricingVariableDefinition_Active DEFAULT 1
GO
ALTER TABLE dbo.PricingVariableDefinition SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'CONTROL') as Contr_Per 


GO

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
ALTER TABLE dbo.PricingVariableDefinition
	DROP CONSTRAINT PK_PricingVariableDefinition
GO
ALTER TABLE dbo.PricingVariableDefinition ADD CONSTRAINT
	PK_PricingVariableDefinition PRIMARY KEY CLUSTERED 
	(
	PricingVariableID,
	LanguageID,
	CountryID,
	PositionID,
	PricingTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PricingVariableDefinition SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PricingVariableDefinition', 'Object', 'CONTROL') as Contr_Per 