CREATE PROCEDURE DropAllObjects
/**
Summary: >
	This is a procedure that deletes an entire database. Before using it please make sure 
	that everything is backed up. It assumes that the login that uses the procedure has 
	the rights to drop database objects. 
	The procedure will drop itself 
Author: Phil Factor
Date: Friday, 17 June 2022
Examples:
   - execute DropAllObjects
Returns: >
  nothing
**/
AS
DECLARE @AllTheDeletes NVARCHAR(MAX) = N'';
DECLARE @ThereAreMoreToDo INT = 20;--we limit the number of loops in case of
-- mutual dependencies
WHILE (@ThereAreMoreToDo >= 0) -- we loop through, deleting objects
  BEGIN
    SELECT @AllTheDeletes =
      @AllTheDeletes + N'DROP  ' + type + N' ' + "SCHEMA" + N'.' + "name"
      + N'; 
' --this generates the DROP statement for the object that is then executed as a string
      FROM -- we get a table source consisting of all the tables, views  and routines.
        (SELECT CASE WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE ' ELSE
                                                                  TABLE_TYPE END AS "type",
                TABLE_SCHEMA AS "schema", TABLE_NAME AS "name"
           FROM INFORMATION_SCHEMA.TABLES
         UNION ALL
         SELECT ROUTINE_TYPE, ROUTINE_SCHEMA, ROUTINE_NAME
           FROM INFORMATION_SCHEMA.ROUTINES) entities("type", "SCHEMA", "name")
        LEFT OUTER JOIN
          (SELECT DISTINCT referenced_schema_name + '.'
                           + referenced_entity_name AS "entity_name"
             FROM
             sys.sql_expression_dependencies
               INNER JOIN sys.objects
                 ON referencing_id = objects.object_id
             WHERE
             referenced_schema_name IS NOT NULL
         AND referenced_minor_id = 0
		 AND referenced_class=1 --assume types done last.
	     AND Referencing_id <> Referenced_id
         AND is_schema_bound_reference = 1
		 --need to filter out self-references!
         AND
           (Coalesce (Object_Name (parent_object_id), objects.name) <> referenced_entity_name
             OR Coalesce (
                  Object_Schema_Name (parent_object_id),
                  Object_Name (object_id)) <> referenced_schema_name)) referenced("entity_name")
          ON referenced."entity_name" = "SCHEMA" + '.' + "name"
        LEFT OUTER JOIN
          (SELECT DISTINCT Object_Schema_Name (referenced_object_id) + '.'
                           + Object_Name (referenced_object_id) AS referenced_name
             FROM sys.foreign_keys) fks(referenced_name)
          ON fks.referenced_name = "SCHEMA" + '.' + "name"
      WHERE
      "entity_name" IS NULL AND fks.referenced_name IS NULL;
    SELECT @ThereAreMoreToDo = CASE WHEN @@RowCount > 0 THEN @ThereAreMoreToDo-1 ELSE 0 end ;
    IF (@ThereAreMoreToDo > 0)
      BEGIN
        IF (@ThereAreMoreToDo =1) RAISERROR ('Couldn''t delete the database',16,1);
        EXEC sp_executesql @AllTheDeletes;
      END;
  END;



  SELECT Count(*) FROM sys.objects WHERE is_ms_shipped =1 
SELECT 
  Sum(CASE is_ms_shipped WHEN 1 THEN 1 ELSE 0 END) AS Is_MS_Shipped,
  Sum(CASE is_Published WHEN 1 THEN 1 ELSE 0 END) AS Is_Published, 
   Sum(CASE is_schema_published WHEN 1 THEN 1 ELSE 0 END )AS Is_Schema_Published
  FROM sys.objects 