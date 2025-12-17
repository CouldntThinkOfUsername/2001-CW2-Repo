2001-CW2-Repo

---------------------------------------------------------------------------------

Repository for COMP2001 Coursework 2
This project contains my implementation files and SQL scripts for Coursework 2 of COMP2001.

The repository includes:
* Authentication API
* SQL scripts for tables, triggers, procedures and views
* Query definitions

---------------------------------------------------------------------------------

REPOSITORY STRUCTURE:
2001-CW2-Repo/

  -Authentication_API/ Authentication related module(s)
  -Create_tables/ SQL scripts to define base tables
  -Create_procedures/ Stored procedures used in the database
  -Create_trigger/ SQL trigger for logging users
  -Create_view/ SQL view
  
CW2_Queries.sql Main SQL query file compiling all of the above

---------------------------------------------------------------------------------

HOW TO USE

Clone the repository
git clone https://github.com/CouldntThinkOfUsername/2001-CW2-Repo.git

* Run schema and table creation scripts first
* Apply all SQL files from the Create_tables folder in your database environment.
* Install stored procedures
* Run all scripts from the Create_procedures folder.
* Create triggers and views
* Execute SQL scripts in Create_trigger and Create_view.

NOTE: order is important — tables, procedures, triggers, views

---------------------------------------------------------------------------------

FILE DESCRIPTIONS

Authentication_API
Contains source code for authentication API.

Create_tables
Contains SQL scripts for creating tables.

Create_procedures
Contains stored procedures.

Create_trigger
Contains trigger definition.

Create_view
Contains the SQL view.

CW2_Queries.sql
Contains the entire query file with all compiled.

---------------------------------------------------------------------------------

TESTING

To test the database:
* Start database server
* Connect
* Run the scripts in the order listed above

---------------------------------------------------------------------------------
