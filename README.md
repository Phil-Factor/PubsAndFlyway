# Pubs & Flyway
This project is a collection of four simple illustrations of building a database with Flyway.  has been designed just to make it a bit easier for SQL Server people who would like to try out using Flyway. I decided that it would be useful to start simple just because there are so many options, flags and actions that are possible with this database build system. All the details of using these is in the accompanying articles

## PubsFlywayBuild

First  off we show a simple way of building the original Pubs Database with  a build scripot. Then we alter it (actually a new file) and show how Flyway will obligingly build it. We show that, if we decide to revert to c 1.1.1, it gets rather awkward and we need to rename files...

| Name                                               | Description                                                  | Version |
| -------------------------------------------------- | ------------------------------------------------------------ | ------- |
| R__V1-1-1_Original_Altered_For_SQL_Server_2017.sql | Build script to create the Pubs database with original data  | 1.1.1   |
| R__V1-1-2_Introduced_Tags.sql                      | Added tags instead of using a simple 'type' for a title, so that a publication can have more than one type | 1.1.2   |

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

