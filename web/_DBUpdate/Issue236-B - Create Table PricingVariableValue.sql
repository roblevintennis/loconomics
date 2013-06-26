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
CREATE TABLE dbo.PricingVariableValue
	(
	PricingVariableID int NOT NULL,
	ProviderPackageID int NOT NULL,
	UserID int NOT NULL,
	PricingEstimateID int NOT NULL,
	PricingEstimateRevision int NOT NULL,
	Value varchar(100) NOT NULL,
	ProviderNumberIncluded decimal(7, 2) NULL,
	ProviderMinNumberAllowed decimal(7, 2) NULL,
	ProviderMaxNumberAllowed decimal(7, 2) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PricingVariableValue ADD CONSTRAINT
	PK_PricingVariableValue PRIMARY KEY CLUSTERED 
	(
	PricingVariableID,
	ProviderPackageID,
	UserID,
	PricingEstimateID,
	PricingEstimateRevision
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PricingVariableValue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PricingVariableValue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PricingVariableValue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PricingVariableValue', 'Object', 'CONTROL') as Contr_Per 

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
ALTER TABLE dbo.PricingVariableValue ADD
	CreatedDate datetime NOT NULL CONSTRAINT DF_PricingVariableValue_CreatedDate DEFAULT (getdate()),
	UpdatedDate datetime NOT NULL CONSTRAINT DF_PricingVariableValue_UpdatedDate DEFAULT (getdate()),
	ModifiedBy varchar(25) NOT NULL CONSTRAINT DF_PricingVariableValue_ModifiedBy DEFAULT 'sys',
	Active bit NOT NULL CONSTRAINT DF_PricingVariableValue_Active DEFAULT 1
GO
ALTER TABLE dbo.PricingVariableValue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.PricingVariableValue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.PricingVariableValue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.PricingVariableValue', 'Object', 'CONTROL') as Contr_Per 