# Pubs & Flyway
This project is a collection of simple illustrations of building a database with Flyway.  has been designed just to make it a bit easier for SQL Server people who would like to try out using Flyway. I decided that it would be useful to start simple just because there are so many options, flags and actions that are possible with this database build system. All the details of using these is in the accompanying articles. These grow in complexity until we reach the PubsFlywayTeamsMigration that allows undo, uses callbacks, static scripts and so on. I also show how to do simple builds with BCP of data, just for shell-shocked traditional developers who strain to see the many virtues of Flyway.

These various projects are

- PubsAgnostic

- PubsFlywayBaselinedMigration

- PubsFlywayBuild

- PubsFlywayHistorySchema

- PubsFlywayLittleMigration

- PubsFlywayMigration

- PubsFlywaySecondMigration

- PubsFlywayTeamsBuild

- PubsFlywayTeamsMigration

- PubsMariaDB

- PubsPostgreSQL

- PubsSQLite

#The Flyway Articles

I've written several articles, with plenty in the pipeline, to explain the many features of Flyway, using sample code that you can play with to get familiar with the system. I'm one of those who learn best by doing stuff, and you could be similar.

### [Flyway Without the Typing](https://www.red-gate.com/hub/product-learning/flyway/flyway-without-the-typing)

  How to use Flyway configuration files to minimize typing during ad-hoc development from PowerShell or DOS; you just type in the Flyway commands you need and hit "go" and the config files take care of all the tiresome connection, authentication and project details. [

### [Dealing with Failed SQL Migrations in MariaDB or MySQL](https://www.red-gate.com/hub/product-learning/flyway/dealing-with-failed-sql-migrations-in-mariadb-or-mysql)

This article explains the fastest ways to restore the previous version of the database, to recover from a failed Flyway migration that leaves the database in an indeterminate state, and then how to adapt your database development process to avoid these problems

### [Flyway with MariaDB for Those of a Nervous Disposition](https://www.red-gate.com/hub/product-learning/flyway/flyway-with-mariadb-for-those-of-a-nervous-disposition)

This article will get you up and running quickly with Flyway migrations on MariaDB or MySQL databases, from PowerShell.

### [Discovering What’s Changed by Flyway Migrations](https://www.red-gate.com/hub/product-learning/flyway/discovering-whats-changed-by-flyway-migrations)

A set of PowerShell cmdlets that will 'diff' two versions of a database and provide a high-level overview of the major database changes made by successive Flyway migrations. You can 'diff' a SQL Server database to the same one on PostgreSQL and find out which objects are the same and which are different

### [One Flyway Migration Script for Diverse Database Systems](https://www.red-gate.com/hub/product-learning/flyway/one-flyway-migration-script-for-diverse-database-systems)

How to create a single set of SQL migration scripts for Flyway that we can use across multiple database systems, or for all regional variants of a database

As well as the scripts I list below, each project has the support files such as powershell scripts, data and sample reports.

### [Flyway with SQLite for Those of a Nervous Disposition](https://www.red-gate.com/hub/product-learning/flyway/flyway-with-sqlite-for-those-of-a-nervous-disposition)

Get started with running Flyway migrations on SQLite databases, using PowerShell.

### [Getting Started with Flyway Migrations on PostgreSQL](https://www.red-gate.com/hub/product-learning/flyway/getting-started-with-flyway-migrations-on-postgresql)

Use PowerShell to run some Flyway migration scripts that will build, fill and modify a PostgreSQL database.

### [Testing Flyway Migrations Using Transactions](https://www.red-gate.com/hub/product-learning/flyway/testing-flyway-migrations-using-transactions)

When you are using Flyway, how can you test your database migration script first to make sure it works exactly as you intended before you let Flyway execute it? 

### [Branching and Merging in Database Development using Flyway](https://www.red-gate.com/hub/product-learning/redgate-deploy/branching-and-merging-in-database-development-using-flyway)

How to exploit the branching and merging capabilities of Git for scaling up team-based development, when doing Flyway migrations.

### [Managing Database Documentation during Flyway-based Development](https://www.red-gate.com/hub/product-learning/flyway/managing-database-documentation-during-flyway-based-development)

How to create and maintain a 'data dictionary' for your databases, in JSON format, which you can then use to add and update the table descriptions, whenever you build a new version using Flyway

### [Creating Idempotent DDL Scripts for Database Migrations](https://www.red-gate.com/hub/product-learning/flyway/creating-idempotent-ddl-scripts-for-database-migrations)

How to write idempotent DDL scripts that Flyway can run several times on a database, such as after a hotfix has already been applied directly to the production database, without causing errors

### [Detecting Database Drift during Flyway Database Development](https://www.red-gate.com/hub/product-learning/redgate-deploy/detecting-database-drift-during-flyway-database-development)

How to detect database drift prior to running a database migration, so that you can be certain that a database hasn't been subject to any 'uncontrolled' changes that could affect the migration or result in untested changes being deployed to production.

### [Running SQL Code Analysis during Flyway Migrations](https://www.red-gate.com/hub/product-learning/redgate-deploy/running-sql-code-analysis-during-flyway-migrations)

A set of PowerShell automation script tasks for running database build and migrations tasks. This article describes the SQL code analysis task, which will check the syntax of the SQL code in your databases and your migration scripts for 'code smells'

### [Creating Database Build Artifacts when Running Flyway Migrations](https://www.red-gate.com/hub/product-learning/redgate-deploy/creating-database-build-artifacts-when-running-flyway-migrations)

This article provides PowerShell automation scripts for running Flyway database migrations. These scripts use SQL Compare to automatically generate all the required database build artifacts in the version control system, for each Flyway deployment.

### [Batch Processing using Flyway](https://www.red-gate.com/hub/product-learning/flyway/batch-processing-using-flyway)

How to create a batch file that executes any number of database migration tasks across a range of servers and databases, using Flyway.

### [Using Flyway Output in PowerShell](https://www.red-gate.com/hub/product-learning/flyway/using-flyway-output-in-powershell)

How to send Flyway logging and error output to JSON and consume it in PowerShell to produce ad-hoc database migrations reports, including any errors that occurred, the version of the database, runtimes for each migration script and more.

### [Flyway Baselines and Consolidations](https://www.red-gate.com/hub/product-learning/flyway/flyway-baselines-and-consolidations)

Phil Factor demonstrates why we occasionally need to 'baseline' a database, when automating database deployments with Flyway, and a simple way of reducing the number of migration files that are required for a build

### [Getting Data In and Out of SQL Server Flyway Builds](https://www.red-gate.com/hub/product-learning/flyway/getting-data-in-and-out-of-sql-server-flyway-builds)

Phil Factor provides SQL routines to extract data from and load data into a SQL Server database, using BCP, and then a PowerShell automation script that uses Flyway to automatically build a database, from scratch and then fill it with data, ready for testing.

### [Customizing Database Deployments using Flyway Callbacks and Placeholders](https://www.red-gate.com/hub/product-learning/flyway/customizing-database-deployments-using-flyway-callbacks-and-placeholders)

How to customize a database deployment process using Flyway, demonstrating how to incorporate tasks such stamping a version number into the latest database build, or writing to the SQL Server log.

### [Getting Started with Flyway and SQL Server](https://www.red-gate.com/hub/product-learning/flyway/getting-started-with-flyway-and-sql-server)

Phil Factor explains how to get started with Flyway, as simply as possible, using PowerShell. This article provides a practice set of database automation scripts that will build a SQL Server database, and then update it, running a series of migrations scripts that make some schema alterations, and load the database with test data.

### [Managing database changes using Flyway: an Overview](https://www.red-gate.com/hub/product-learning/flyway/managing-database-changes-using-flyway-an-overview)

This article describes the principles of using Flyway migrations to build a database from scripts, to a specified version, and to track, manage and apply all database changes

# The Projects

## PubsAgnostic

This is a project of building the original pubs database for MariaDB, MySQL, PostgreSQL, SQL Server or SQLite, using just one shared source. I get around the difficulties by using placeholders with different settings depending on the database the source is being used for. The common ODBC SQL92 really isn't sufficient even for a simple database such as Pubs, so a little help from placeholders is required.

| Name                               | Description                                                  | Version |
| ---------------------------------- | ------------------------------------------------------------ | ------- |
| **V1.1.1_lnitial_Build.sql**       | This provides an initial build but without the data          | 1.1.1   |
| **VI .1.2_Pubs_0riginal_Data.sql** | This inserts the original initial data                       | 1.1.2   |


## PubsFlywayBuild

For beginners with Flyway, we show a simple way of building the original Pubs Database with  a build scripot. Then we alter it (actually a new file) and show how Flyway will obligingly build it. We show that, if we decide to revert to c 1.1.1, it gets rather awkward and we need to rename files...

| Name                               | Description                                                 | Version |
| ---------------------------------- | ----------------------------------------------------------- | ------- |
| **RV1.1.11BuildSchemaAndData.sql** | Build script to create the Pubs database with original data | 1.1.1   |


## PubsFlywayLittleMigration

First  off we show a simple way of building the original Pubs Database with  a build scripot. Then we alter it (actually a new file) and show how Flyway will obligingly build it. We show that, if we decide to revert to c 1.1.1, it gets rather awkward and we need to rename files...

| Name                                                | Description                                                  | Version |
| --------------------------------------------------- | ------------------------------------------------------------ | ------- |
| **V1-1-1_Original_Altered_For_SQL_Server_2017.sql** | Build script to create the Pubs database with original data  | 1.1.1   |
| **V1-1-2_Introduced_Tags.sql**                      | Migration script to add tags instead of using a simple 'type' for a title, so that a publication can have more than one type | 1.1.2   |

## PubsFlywayMigration

Basically, this just has four files designed to build the initial version of Pubs, slightly modified to allow it to run easily on recent versions of SQL Server. Then there is a very simple modification to allow it to use nvarchars etc, and finally a dataset to replace the original data with five thousand publications so as to provide slightly more realistic data.

| Name                               | Description                                                  | Version |
| ---------------------------------- | ------------------------------------------------------------ | ------- |
| **V1.1.1_lnitial_Build.sql**       | This provides an initial build but without the data          | 1.1.1   |
| **VI .1.2_Pubs_0riginal_Data.sql** | This inserts the original initial data                       | 1.1.2   |
| **V1.1,3_UseNVarcharetc.sql**      | This  alters the data to allow it to take a reasonable amount of data | 1.1.3   |
| **V1.1.4_Add_New_Data.sql**        | This inserts the data. You'll find a lot of humanities Essays here. | 1.1.4   |

## PubsFlywayBaselinedMigration

This illustrates how a baseline works and how provide a more robust way of building the database. Basically, this allows you to experiment in migrating from the old traditional version of Pubs, slightly modified to allow it to run easily on recent versions of SQL Server, and from it to create a version that allows you to catalog various types of edition, all with different prices and so on, and finally adds a dataset to replace the original data with five thousand publications so as to provide slightly more realistic data.

| Name                                            | Description                                                  | Version |
| ----------------------------------------------- | ------------------------------------------------------------ | ------- |
| **V1.1.1_lnitial_Build.sql**                    | This provides an initial build but without the data          | 1.1.1   |
| **VI .1.2_Pubs_0riginal_Data.sql**              | This inserts the original initial data                       | 1.1.2   |
| **V1.1,3_UseNVarcharetc.sql**                   | This  alters the data to allow it to take a reasonable amount of data | 1.1.3   |
| **V1.1.4__BuildAddEditionsAndPublications.sql** | This is inserted into the sequence to create a baseline      | 1.1.4   |
| **V1.1.5__Pubs_Re-apply Original_Data.sql**     | This is needed so that the the original data can be used     | 1.1.5   |
| **V1.1.6_Add_New_Data.sql**                     | This inserts the data. You'll find a lot of humanities Essays here | 1.1.6   |
| **V1.1.7__Add_Tags.sql**                        | Adds the tags                                                | 1.1.7   |



## PubsFlywayHistorySchema
this is a version of the PubsSecondMigration project with an embedded  configuration file that ensures that all participating devs use the same name for the Flyway Schema history table. 

| Name | Description | Version |
| ---- | ----------- | ------- |
|**flyway.conf**|a sample config file that specifies where the flyway schema history file should be||
| **afterMigrate__Add_Version_EP.sql** | This marks the actual database after a migration  with the version number and a description of the database |  |
| **afterMigrate__ApplyTableDescriptions.sql** | Ensures that all the tables and columns are properly documented in the database after a migration. This prevents the clutter of extended properties in the code. |  |
| **V1.1.1__Initial_Build.sql** | This provides an initial build but without the data  | 1.1.1 |
| **V1.1.2__Pubs_Original_Data.sql** | This inserts the original initial data |1.1.2  |
|**V1.1.3__UseNVarcharetc.sql**  |  This  alters the database to allow it to take a reasonable amount of data |  1.1.3  |
|**V1.1.4__RenameConstraintsAdd tables.sql**  | This tidies up the data structures |   1.1.4   |
|**V1.1.5__Add_New_Data.sql**  | This inserts the data. You'll find a lot of humanities Essays here |  1.1.5    |
|**V1.1.6__Add_Tags.sql**  | Add the tags to allow publications to have several tags |   1.1.6   |
|**V1.1.7__Add_Indexes.sql**  |  Add any indexes that code review identifies as being missing  |   1.1.7   |
|**V1.1.8__AddEditionData.sql**  | add tables and data to allow the storage of different types of publication such as ebooks and pdfs. |  1.1.8    |
|**V1.1.9__AddconditionalVersion.sql**  |  demonstrates how to add code that  may not be supported by the version of SQL Server |   1.1.9   |
|**V1.1.10__AddAddressesPhonesEtc.sql**  | Add the schema that is used for managing people and their complexitied  |  1.1.10    |
|**V1.1.11__AddProcedureWithTest.sql**  |  demonstrates how to add unit  tests to ensure that the migration actually works |  1.1.1 1  |

## PubsFlywaySecondMigration
This is the standard SQL Server migration for the pubs database, designed to work with Flyway Community

| Name | Description | Version |
| ---- | ----------- | ------- |
| **afterMigrate__Add_Version_EP.sql** | This marks the actual database after a migration  with the version number and a description of the database |  |
| **afterMigrate__ApplyTableDescriptions.sql** | Ensures that all the tables and columns are properly documented in the database after a migration. This prevents the clutter of extended properties in the code. |  |
| **V1.1.1__Initial_Build.sql** | This provides an initial build but without the data  | 1.1.1 |
| **V1.1.2__Pubs_Original_Data.sql** | This inserts the original initial data |1.1.2  |
|**V1.1.3__UseNVarcharetc.sql**  |  This  alters the database to allow it to take a reasonable amount of data |  1.1.3  |
|**V1.1.4__RenameConstraintsAdd tables.sql**  | This tidies up the data structures |   1.1.4   |
|**V1.1.5__Add_New_Data.sql**  | This inserts the data. You'll find a lot of humanities Essays here |  1.1.5    |
|**V1.1.6__Add_Tags.sql**  | Add the tags to allow publications to have several tags |   1.1.6   |
|**V1.1.7__Add_Indexes.sql**  |  Add any indexes that code review identifies as being missing  |   1.1.7   |
|**V1.1.8__AddEditionData.sql**  | add tables and data to allow the storage of different types of publication such as ebooks and pdfs. |  1.1.8    |
|**V1.1.9__AddconditionalVersion.sql**  |  demonstrates how to add code that  may not be supported by the version of SQL Server |   1.1.9   |
|**V1.1.10__AddAddressesPhonesEtc.sql**  | Add the schema that is used for managing people and their complexitied  |  1.1.10    |
|**V1.1.11__AddProcedureWithTest.sql**  |  demonstrates how to add unit  tests to ensure that the migration actually works |  1.1.1 1  |


## PubsFlywayTeamsBuild
This version of the database demonstrates how to do a build with BCP input of data for provisioning SQL Server databases

| Name | Description | Version |
| ---- | ----------- | ------- |
| **S1.1.11__BuildSchema.sql** | Builds the entire schem up to version 11 but without the data      |S1.1.11|
| **V1.1.12__ImportData.ps1** |  the script that BCPs in the data    |V1.1.12__ImportData.ps1|




## PubsFlywayTeamsMigration
This is a version of the Pubs Flyway Second migration that is designed for demonstrating the features of Flyway Teams, including the UNDO and call-back PowerShell scripts

| Name | Description | Version |
| ---- | ----------- | ------- |
| **afterMigrate__Add_Version_EP.sql** | This marks the actual database after a migration  with the version number and a description of the database |  |
| **afterMigrate__ApplyTableDescriptions.sql** | Ensures that all the tables and columns are properly documented in the database after a migration. This prevents the clutter of extended properties in the code. |  |
| **afterVersioned__Narrative.ps1** | add to the narrative of changes after a migration   |     |
| **DontDoafterMigrate__Build.ps1** | performs a whole lot of tasks such as doing a code review and creating build scripts   |     |
| **DontDoafterVersioned__Report.ps1** | maintains a report in SQLite of all the migration actions performed   |     |
| **DontDoS1.1.11__BuildSchemaAndData.sql** | a static script that will build any new database rather than run it through all the past migrations   |     |
| **U1.1.1__Initial_Build.sql** |Undo file that takes the version back to zero (empty database)   |     |
| **U1.1.2__Pubs_Original_Data.sql** | Undo file that takes the version back to 1.1.1    |     |
| **U1.1.3__UseNVarcharetc.sql** | Undo file that takes the version back to 1.1.2    |     |
| **U1.1.4__RenameConstraintsAdd tables.sql** | Undo file that takes the version back to 1.1.3    |     |
| **U1.1.5__Add_New_Data.sql** | Undo file that takes the version back to 1.1.4    |     |
| **U1.1.6__Add_Tags.sql** |  Undo file that takes the version back to 1.1.5   |     |
| **U1.1.7__Add_Indexes.sql** | Undo file that takes the version back to 1.1.6    |     |
| **U1.1.8__AddEditions.sql** | Undo file that takes the version back to 1.1.7    |     |
| **U1.1.9__AddconditionalVersion.sql** | Undo file that takes the version back to 1.1.8    |     |
| **U1.1.10__AddAddressesPhonesEtc.sql** |  Undo file that takes the version back to 1.1.9   |     |
| **U1.1.11__AddProcedureWithTest.sql** |  Undo file that takes the version back to 1.1.10   |     |
| **afterMigrate__Add_Version_EP.sql** | This marks the actual database after a migration  with the version number and a description of the database |  |
| **afterMigrate__ApplyTableDescriptions.sql** | Ensures that all the tables and columns are properly documented in the database after a migration. This prevents the clutter of extended properties in the code. |  |
| **V1.1.1__Initial_Build.sql** | This provides an initial build but without the data  | 1.1.1 |
| **V1.1.2__Pubs_Original_Data.sql** | This inserts the original initial data |1.1.2  |
|**V1.1.3__UseNVarcharetc.sql**  |  This  alters the database to allow it to take a reasonable amount of data |  1.1.3  |
|**V1.1.4__RenameConstraintsAdd tables.sql**  | This tidies up the data structures |   1.1.4   |
|**V1.1.5__Add_New_Data.sql**  | This inserts the data. You'll find a lot of humanities Essays here |  1.1.5    |
|**V1.1.6__Add_Tags.sql**  | Add the tags to allow publications to have several tags |   1.1.6   |
|**V1.1.7__Add_Indexes.sql**  |  Add any indexes that code review identifies as being missing  |   1.1.7   |
|**V1.1.8__AddEditionData.sql**  | add tables and data to allow the storage of different types of publication such as ebooks and pdfs. |  1.1.8    |
|**V1.1.9__AddconditionalVersion.sql**  |  demonstrates how to add code that  may not be supported by the version of SQL Server |   1.1.9   |
|**V1.1.10__AddAddressesPhonesEtc.sql**  | Add the schema that is used for managing people and their complexitied  |  1.1.10    |
|**V1.1.11__AddProcedureWithTest.sql**  |  demonstrates how to add unit  tests to ensure that the migration actually works |  1.1.1 1  |


## PubsMariaDB
A version of the Pubs database as a set of migration files, designed for use with MariaDB and MySQL 

| Name | Description | Version |
| ---- | ----------- | ------- |
| **V1.1.1__Initial_Build.sql** | This provides an initial build but without the data  | 1.1.1 |
| **V1.1.2__Pubs_Original_Data.sql** | This inserts the original initial data |1.1.2  |
|**V1.1.3__UseNVarcharetc.sql**  |  This  alters the database to allow it to take a reasonable amount of data |  1.1.3  |
|**V1.1.4__RenameConstraintsAdd tables.sql**  | This tidies up the data structures |   1.1.4   |
|**V1.1.5__Add_New_Data.sql**  | This inserts the data. You'll find a lot of humanities Essays here |  1.1.5    |
|**V1.1.6__Add_Tags.sql**  | Add the tags to allow publications to have several tags |   1.1.6   |
|**V1.1.7__Add_Indexes.sql**  |  Add any indexes that code review identifies as being missing  |   1.1.7   |

## PubsPostgreSQL
A version of the Pubs database as a set of migration files, designed for use with PostgreSQL

| Name | Description | Version |
| ---- | ----------- | ------- |
| **V1.1.1__Initial_Build.sql** | This provides an initial build but without the data  | 1.1.1 |
| **V1.1.2__Pubs_Original_Data.sql** | This inserts the original initial data |1.1.2  |
|**V1.1.3__UseNVarcharetc.sql**  |  This  alters the database to allow it to take a reasonable amount of data |  1.1.3  |
|**V1.1.4__RenameConstraintsAdd tables.sql**  | This tidies up the data structures |   1.1.4   |
|**V1.1.5__Add_New_Data.sql**  | This inserts the data. You'll find a lot of humanities Essays here |  1.1.5    |
|**V1.1.6__Add_Tags.sql**  | Add the tags to allow publications to have several tags |   1.1.6   |

## PubsSQLite
A version of the Pubs database as a set of migration files, designed for use with SQLite

| Name | Description | Version |
| ---- | ----------- | ------- |
| **V1.1.1__Initial_Build.sql** | This provides an initial build but without the data  | 1.1.1 |
| **V1.1.2__Pubs_Original_Data.sql** | This inserts the original initial data |1.1.2  |
|**V1.1.3__UseNVarcharetc.sql**  |  This  alters the database to allow it to take a reasonable amount of data |  1.1.3  |
|**V1.1.4__RenameConstraintsAdd tables.sql**  | This tidies up the data structures |   1.1.4   |
|**V1.1.5__Add_New_Data.sql**  | This inserts the data. You'll find a lot of humanities Essays here |  1.1.5    |
|**V1.1.6__Add_Tags.sql**  | Add the tags to allow publications to have several tags |   1.1.6   |

