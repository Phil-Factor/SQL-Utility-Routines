/***
Summary: >
	This is a batch that deletes an entire database. Before using it please make sure 
	that everything is backed up. It assumes that the login that uses the procedure has 
	the rights to drop database objects. 
Author: Phil Factor
Date: Friday, 17 June 2022
Revision: Friday, 5th August 2022

**/



  DECLARE @AllTheDeletes NVARCHAR(MAX) = N'';
  DECLARE @ThereAreMoreToDo INT = 20; --we limit the number of loops in case of
  DECLARE @NumberOfDeletions INT;

  --start by deleting the object types that just have dependencies and EPs on the database.
  SELECT @AllTheDeletes=N''
  SELECT @AllTheDeletes=@AllTheDeletes + N'print ''dropping ' + Type + N' ' + fullname + N''';
	DROP  ' + Type + N' ' + fullname + ' ' + scope + N';'
		FROM 
      ( SELECT 'TRIGGER' AS "Type", QuoteName (name) AS fullname, 'ON DATABASE' AS scope
        FROM sys.triggers tr WHERE parent_id=0)f

  SELECT @AllTheDeletes=@AllTheDeletes +'EXEC sp_dropextendedproperty @name = N'''+name+''';'
    FROM sys.extended_properties WHERE major_id=0 AND minor_id=0;
  SELECT @AllTheDeletes=@AllTheDeletes + 'EXEC sp_dropextendedproperty  N'''+ep.name+''', ''Filegroup'', '''+data_spaces.name+''';
'	FROM sys.data_spaces
	INNER JOIN sys.extended_properties ep
	ON ep.major_id = data_spaces.data_space_id
	WHERE class_desc = 'dataspace'  
  EXEC sp_executesql @AllTheDeletes; --- AND do them all
--awkward SQL just in case more crop up. 
  WHILE (@ThereAreMoreToDo > 0) -- we loop through, deleting objects
    BEGIN
      PRINT @ThereAreMoreToDo;
      SELECT @AllTheDeletes = N'';
      SELECT @AllTheDeletes =
        @AllTheDeletes + N'print ''dropping ' + type + N' '
        + QuoteName ("SCHEMA") + N'.' + QuoteName ("name") + N''';
	DROP  '                     + type + N' ' + QuoteName ("SCHEMA") + N'.'
        + QuoteName ("name") + N';'
        --this generates the DROP statement for the object that is then executed as a string
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
           AND referenced_class = 1 --assume types done last.
           AND referencing_id <> referenced_id
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
      SELECT @NumberOfDeletions = @@RowCount;
      SELECT @ThereAreMoreToDo =
        CASE WHEN @NumberOfDeletions > 0 THEN @ThereAreMoreToDo - 1 ELSE 0 END;
      IF (@ThereAreMoreToDo > 0)
        BEGIN
          IF (@ThereAreMoreToDo = 1)
            BEGIN
              RAISERROR (
                'Couldn''t delete the database because of mutual references',
                16,
                1);
              SELECT @ThereAreMoreToDo = 0;
            END;
          EXEC sp_executesql @AllTheDeletes;
        END;
    END;
  SELECT @AllTheDeletes = N'';
  SELECT @AllTheDeletes =
    @AllTheDeletes + N'print ''dropping ' + Type + N' ' + fullname
    + N''';
	DROP  ' + Type + N' ' + fullname + ' ' + scope + N';'
    --this generates the DROP statement for the object that is then executed as a string
    FROM
      (SELECT 'XML SCHEMA COLLECTION' AS "Type",
              QuoteName (Schema_Name (xc.schema_id)) + '.'
              + QuoteName (xc.name) AS fullname,'' AS scope
         FROM
         sys.xml_schema_collections xc
           INNER JOIN sys.schemas
             ON schemas.schema_id = xc.schema_id
         WHERE schemas.name <> 'sys'
         UNION ALL
       SELECT 'TYPE' AS "Type",
              QuoteName (Schema_Name (schema_id)) + '.' + QuoteName (name) AS fullname,'' AS scope
         FROM sys.types UT
         WHERE
         UT.user_type_id <> UT.system_type_id
     AND Schema_Name (UT.schema_id) <> 'sys'
       UNION ALL
       SELECT 'SCHEMA' AS "Type", QuoteName (name) AS fullname,'' AS scope
         FROM sys.schemas sch
         WHERE
         sch.schema_id > 4 AND sch.name NOT LIKE 'DB%') f;
  EXEC sp_executesql @AllTheDeletes;

