# PubsFlywayMigration
This project has been designed just to make it a bit easier for SQL Server people who would like to try out using Flyway. I decided that it would be useful to start simple just because there are so many options, flags and actions that are possible with this database build system.

Basically, this just has four files designed to build the initial version of Pubs, slightly modified to allow it to run easily on recent versions of SQL Server. Then there is a very simple modification to allow it to use nvarchars etc, and finally a dataset to replace the original data with five thousand publications so as to provide slightly more realistic data.

| **V1.1.1_lnitial_Build.sql**       | This provides an initial build but without the data          | 1.1.1 |
| ---------------------------------- | ------------------------------------------------------------ | ----- |
| **VI .1.2_Pubs_0riginal_Data.sql** | This inserts the original initial data                       | 1.1.2 |
| **V1.1,3_UseNVarcharetc.sql**      | This  alters the data to allow it to take a reasonable amount of data | 1.1.3 |
| **V1.1.4_Add_New_Data.sql**        | This inserts the data. You'll find a lot of humanities Essays here. | 1.1.4 |

