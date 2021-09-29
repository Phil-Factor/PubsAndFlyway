SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping foreign keys from [People].[Abode]'
GO
if (IF OBJECT_ID('[Abode_AddressFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Abode] DROP CONSTRAINT [Abode_AddressFK]
GO
if (IF OBJECT_ID('[Abode_AddressTypeFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Abode] DROP CONSTRAINT [Abode_AddressTypeFK]
GO
if (IF OBJECT_ID('[Abode_PersonFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Abode] DROP CONSTRAINT [Abode_PersonFK]
GO
PRINT N'Dropping foreign keys from [People].[CreditCard]'
GO
if (IF OBJECT_ID('[CreditCard_PersonFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[CreditCard] DROP CONSTRAINT [CreditCard_PersonFK]
GO
PRINT N'Dropping foreign keys from [People].[EmailAddress]'
GO
if (IF OBJECT_ID('[EmailAddress_PersonFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[EmailAddress] DROP CONSTRAINT [EmailAddress_PersonFK]
GO
PRINT N'Dropping foreign keys from [People].[Location]'
GO
if (IF OBJECT_ID('[Location_AddressFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Location] DROP CONSTRAINT [Location_AddressFK]
GO
if (IF OBJECT_ID('[Location_AddressTypeFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Location] DROP CONSTRAINT [Location_AddressTypeFK]
GO
if (IF OBJECT_ID('[Location_organisationFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Location] DROP CONSTRAINT [Location_organisationFK]
GO
PRINT N'Dropping foreign keys from [People].[NotePerson]'
GO
if (IF OBJECT_ID('[NotePerson_NoteFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[NotePerson] DROP CONSTRAINT [NotePerson_NoteFK]
GO
if (IF OBJECT_ID('[NotePerson_PersonFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[NotePerson] DROP CONSTRAINT [NotePerson_PersonFK]
GO
PRINT N'Dropping foreign keys from [People].[Phone]'
GO
if (IF OBJECT_ID('[FK__Phone__TypeOfPho__09003183]', 'C') IS NOT NULL ) ALTER TABLE [People].[Phone] DROP CONSTRAINT [FK__Phone__TypeOfPho__09003183]
GO
if (IF OBJECT_ID('[Phone_PersonFK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Phone] DROP CONSTRAINT [Phone_PersonFK]
GO
PRINT N'Dropping constraints from [People].[Address]'
GO
if (IF OBJECT_ID('[Address_Not_Complete]', 'C') IS NOT NULL ) ALTER TABLE [People].[Address] DROP CONSTRAINT [Address_Not_Complete]
GO
PRINT N'Dropping constraints from [People].[Abode]'
GO
if (IF OBJECT_ID('[AbodePK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Abode] DROP CONSTRAINT [AbodePK]
GO
PRINT N'Dropping constraints from [People].[AddressType]'
GO
if (IF OBJECT_ID('[TypeOfAddressPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[AddressType] DROP CONSTRAINT [TypeOfAddressPK]
GO
PRINT N'Dropping constraints from [People].[Address]'
GO
if (IF OBJECT_ID('[AddressPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Address] DROP CONSTRAINT [AddressPK]
GO
PRINT N'Dropping constraints from [People].[CreditCard]'
GO
if (IF OBJECT_ID('[CreditCardPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[CreditCard] DROP CONSTRAINT [CreditCardPK]
GO
PRINT N'Dropping constraints from [People].[CreditCard]'
GO
if (IF OBJECT_ID('[DuplicateCreditCardUK]', 'C') IS NOT NULL ) ALTER TABLE [People].[CreditCard] DROP CONSTRAINT [DuplicateCreditCardUK]
GO
PRINT N'Dropping constraints from [People].[CreditCard]'
GO
if (IF OBJECT_ID('[CreditCardWasntUnique]', 'C') IS NOT NULL ) ALTER TABLE [People].[CreditCard] DROP CONSTRAINT [CreditCardWasntUnique]
GO
PRINT N'Dropping constraints from [People].[EmailAddress]'
GO
if (IF OBJECT_ID('[EmailPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[EmailAddress] DROP CONSTRAINT [EmailPK]
GO
PRINT N'Dropping constraints from [People].[Location]'
GO
if (IF OBJECT_ID('[LocationPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Location] DROP CONSTRAINT [LocationPK]
GO
PRINT N'Dropping constraints from [People].[NotePerson]'
GO
if (IF OBJECT_ID('[NotePersonPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[NotePerson] DROP CONSTRAINT [NotePersonPK]
GO
PRINT N'Dropping constraints from [People].[NotePerson]'
GO
if (IF OBJECT_ID('[DuplicateUK]', 'C') IS NOT NULL ) ALTER TABLE [People].[NotePerson] DROP CONSTRAINT [DuplicateUK]
GO
PRINT N'Dropping constraints from [People].[Note]'
GO
if (IF OBJECT_ID('[NotePK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Note] DROP CONSTRAINT [NotePK]
GO
PRINT N'Dropping constraints from [People].[Organisation]'
GO
if (IF OBJECT_ID('[organisationIDPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Organisation] DROP CONSTRAINT [organisationIDPK]
GO
PRINT N'Dropping constraints from [People].[Person]'
GO
if (IF OBJECT_ID('[PersonIDPK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Person] DROP CONSTRAINT [PersonIDPK]
GO
PRINT N'Dropping constraints from [People].[PhoneType]'
GO
if (IF OBJECT_ID('[PhoneTypePK]', 'C') IS NOT NULL ) ALTER TABLE [People].[PhoneType] DROP CONSTRAINT [PhoneTypePK]
GO
PRINT N'Dropping constraints from [People].[Phone]'
GO
if (IF OBJECT_ID('[PhonePK]', 'C') IS NOT NULL ) ALTER TABLE [People].[Phone] DROP CONSTRAINT [PhonePK]
GO
PRINT N'Dropping constraints from [People].[Abode]'
GO
if (IF OBJECT_ID('[AbodeModifiedD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Abode] DROP CONSTRAINT [AbodeModifiedD]
GO
PRINT N'Dropping constraints from [People].[AddressType]'
GO
if (IF OBJECT_ID('[AddressTypeModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[AddressType] DROP CONSTRAINT [AddressTypeModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[Address]'
GO
if (IF OBJECT_ID('[AddressModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Address] DROP CONSTRAINT [AddressModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[CreditCard]'
GO
if (IF OBJECT_ID('[CreditCardModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[CreditCard] DROP CONSTRAINT [CreditCardModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[EmailAddress]'
GO
if (IF OBJECT_ID('[DF__EmailAddr__Start__1EEF72A2]', 'C') IS NOT NULL ) ALTER TABLE [People].[EmailAddress] DROP CONSTRAINT [DF__EmailAddr__Start__1EEF72A2]
GO
PRINT N'Dropping constraints from [People].[EmailAddress]'
GO
if (IF OBJECT_ID('[EmailAddressModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[EmailAddress] DROP CONSTRAINT [EmailAddressModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[Location]'
GO
if (IF OBJECT_ID('[LocationModifiedD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Location] DROP CONSTRAINT [LocationModifiedD]
GO
PRINT N'Dropping constraints from [People].[NotePerson]'
GO
if (IF OBJECT_ID('[NotePersonInsertionDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[NotePerson] DROP CONSTRAINT [NotePersonInsertionDateD]
GO
PRINT N'Dropping constraints from [People].[NotePerson]'
GO
if (IF OBJECT_ID('[NotePersonModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[NotePerson] DROP CONSTRAINT [NotePersonModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[Note]'
GO
if (IF OBJECT_ID('[NoteInsertionDateDL]', 'C') IS NOT NULL ) ALTER TABLE [People].[Note] DROP CONSTRAINT [NoteInsertionDateDL]
GO
PRINT N'Dropping constraints from [People].[Note]'
GO
if (IF OBJECT_ID('[GetUserName]', 'C') IS NOT NULL ) ALTER TABLE [People].[Note] DROP CONSTRAINT [GetUserName]
GO
PRINT N'Dropping constraints from [People].[Note]'
GO
if (IF OBJECT_ID('[NoteModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Note] DROP CONSTRAINT [NoteModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[Organisation]'
GO
if (IF OBJECT_ID('[organisationModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Organisation] DROP CONSTRAINT [organisationModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[Person]'
GO
if (IF OBJECT_ID('[PersonModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Person] DROP CONSTRAINT [PersonModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[PhoneType]'
GO
if (IF OBJECT_ID('[PhoneTypeModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[PhoneType] DROP CONSTRAINT [PhoneTypeModifiedDateD]
GO
PRINT N'Dropping constraints from [People].[Phone]'
GO
if (IF OBJECT_ID('[PhoneModifiedDateD]', 'C') IS NOT NULL ) ALTER TABLE [People].[Phone] DROP CONSTRAINT [PhoneModifiedDateD]
GO
PRINT N'Dropping index [SearchByOrganisationName] from [People].[Organisation]'
GO
DROP INDEX [SearchByOrganisationName] ON [People].[Organisation]
GO
PRINT N'Dropping index [SearchByPersonLastname] from [People].[Person]'
GO
DROP INDEX [SearchByPersonLastname] ON [People].[Person]
GO
PRINT N'Dropping [People].[publishers]'
GO
if (IF OBJECT_ID('[People].[publishers]', 'V') IS NOT NULL ) DROP VIEW [People].[publishers]
GO
PRINT N'Dropping [People].[authors]'
GO
if (IF OBJECT_ID('[People].[authors]', 'V') IS NOT NULL ) DROP VIEW [People].[authors]
GO
PRINT N'Dropping [People].[PhoneType]'
GO
if (IF OBJECT_ID('[People].[PhoneType]', 'U') IS NOT NULL ) DROP VIEW [People].[PhoneType]
GO
PRINT N'Dropping [People].[Phone]'
GO
if (IF OBJECT_ID('[People].[Phone]', 'U') IS NOT NULL ) DROP VIEW [People].[Phone]
GO
PRINT N'Dropping [People].[Person]'
GO
if (IF OBJECT_ID('[People].[Person]', 'U') IS NOT NULL ) DROP VIEW [People].[Person]
GO
PRINT N'Dropping [People].[Organisation]'
GO
if (IF OBJECT_ID('[People].[Organisation]', 'U') IS NOT NULL ) DROP VIEW [People].[Organisation]
GO
PRINT N'Dropping [People].[NotePerson]'
GO
if (IF OBJECT_ID('[People].[NotePerson]', 'U') IS NOT NULL ) DROP VIEW [People].[NotePerson]
GO
PRINT N'Dropping [People].[Note]'
GO
if (IF OBJECT_ID('[People].[Note]', 'U') IS NOT NULL ) DROP VIEW [People].[Note]
GO
PRINT N'Dropping [People].[Location]'
GO
if (IF OBJECT_ID('[People].[Location]', 'U') IS NOT NULL ) DROP VIEW [People].[Location]
GO
PRINT N'Dropping [People].[EmailAddress]'
GO
if (IF OBJECT_ID('[People].[EmailAddress]', 'U') IS NOT NULL ) DROP VIEW [People].[EmailAddress]
GO
PRINT N'Dropping [People].[CreditCard]'
GO
if (IF OBJECT_ID('[People].[CreditCard]', 'U') IS NOT NULL ) DROP VIEW [People].[CreditCard]
GO
PRINT N'Dropping [People].[AddressType]'
GO
if (IF OBJECT_ID('[People].[AddressType]', 'U') IS NOT NULL ) DROP VIEW [People].[AddressType]
GO
PRINT N'Dropping [People].[Address]'
GO
if (IF OBJECT_ID('[People].[Address]', 'U') IS NOT NULL ) DROP VIEW [People].[Address]
GO
PRINT N'Dropping [People].[Abode]'
GO
if (IF OBJECT_ID('[People].[Abode]', 'U') IS NOT NULL ) DROP VIEW [People].[Abode]
GO
PRINT N'Dropping types'
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalAddressline]' AND is_user_defined=1)  DROP TYPE [People].[PersonalAddressline]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalCVC]' AND is_user_defined=1)  DROP TYPE [People].[PersonalCVC]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalEmailAddress]' AND is_user_defined=1)  DROP TYPE [People].[PersonalEmailAddress]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalLocation]' AND is_user_defined=1)  DROP TYPE [People].[PersonalLocation]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalName]' AND is_user_defined=1)  DROP TYPE [People].[PersonalName]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalNote]' AND is_user_defined=1)  DROP TYPE [People].[PersonalNote]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalPaymentCardNumber]' AND is_user_defined=1)  DROP TYPE [People].[PersonalPaymentCardNumber]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalPhoneNumber]' AND is_user_defined=1)  DROP TYPE [People].[PersonalPhoneNumber]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalPostalCode]' AND is_user_defined=1)  DROP TYPE [People].[PersonalPostalCode]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalSuffix]' AND is_user_defined=1)  DROP TYPE [People].[PersonalSuffix]
GO
IF EXISTS(SELECT 1 FROM sys.types WHERE name LIKE '[People].[PersonalTitle]' AND is_user_defined=1)  DROP TYPE [People].[PersonalTitle]
GO
DECLARE @Version NVARCHAR(10) = N'1.1.9';
DECLARE @Database NVARCHAR(3000);
SELECT @Database = N'${flyway:database}';
DECLARE @DatabaseInfo NVARCHAR(3000) =
          (SELECT @Database AS "Name", @Version AS "Version",
                  N'${projectDescription}' AS "Description",
                  N'${projectName}' AS "Project", GetDate () AS "Modified",
                  SUser_Name () AS "by"
          FOR JSON PATH);
IF NOT EXISTS
  (SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
     FROM
     sys.fn_listextendedproperty (
       N'Database_Info', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) )
  EXEC sys.sp_addextendedproperty @name = N'Database_Info',
                                  @value = @DatabaseInfo;
ELSE
  EXEC sys.sp_updateextendedproperty @name = N'Database_Info',
                                     @value = @DatabaseInfo;