# SQL-Utility-Routines

### PROCEDURE DropAllObjects

This is a procedure that deletes an entire database. Before using it please make sure that everything is backed up. It assumes that the login that uses the procedure has the rights to drop database objects. 

This is used for clean out tests while leaving the database itself ready for the next build. As it is used normally with Flyway, it does not drop the schemas. It works by calculating the dependencies that would otherwise cause an error, and drops all objects in dependency order. It was inspired by Adventureworks, that has a clever dependency of a table on a function, thereby defeating all the normal tricks of deleting databases.

The procedure will drop itself 
Initial creation Date: Friday, 17 June 2022
Example:

`execute DropAllObjects`

### Table-valued FUNCTION dbo.SchemaObjects

Returns the full names, names, path and comments/documentation of all the schema objects, their name, path, comments (Extended properties) and so on.  This is normally used for full searches of a database.

Initial creation Date: Tuesday, 28 June 2022

Examples:

   - `Select * from SchemaObjects() order by path`
   - `Select  Name, path, Comment from SchemaObjects() `
     ` where Name+comment like '%credit%' order by path`
   - `Select  Name, path, Comment from SchemaObjects() `
     ` where path like '%person.table.businessentity.%'`
   - `Select  Name, path, Comment from SchemaObjects() `
  ` where path like '%.foreign_key_constraint.%'Returns: >`

### VIEW The_Metadata

 This is a that lists all of all the database-level attributes and schema-based objects  of the current database to allow a comprehensive search This references FUNCTION dbo.SchemaObjects which needs to be created first.

Initial creation Date: Tuesday, 28 June 2022

Examples:

- `Select Name, Path, Comment from The_Metadata where name+' '+comment like '%credit%' order by path`
- `Select * from The_Metadata where path like '$.Attributes%'` 
