/**
Summary: >
 This is designed to be run in SQLCmd or SSMS.
 Here is a query that produces a JSON data document for an entire database. You might need this 
 when creating your script or when finding out what changes have been made that need to be documented. 
 Most of the time, you'll use the JSON script as the 'Master' source of documentation because it tells 
 you what hasn't yet been documented: it has a NULL against it. (There will be a blank string assigned 
 to it if there is a zero-length string assigned to the extended property).
Author: Phil Factor
Date: 2021-05-28
Returns: >
  JSON document of documentation
**/


DECLARE @JSON NVARCHAR(MAX);
SELECT @JSON =
  (
  SELECT Object_Schema_Name(tables.object_id) + '.' + tables.name AS TableObjectName,
    Lower(Replace(type_desc, '_', ' ')) AS [Type], --the type of table source
    Coalesce(Convert(NVARCHAR(3800), ep.value), '') AS "Description",
     (
     SELECT JSON_Query('{' + String_Agg(EachAttribute.attribute, ',') + '}')
     FROM
       (SELECT '"'+type_desc+'":{'
          +String_Agg(
        '"'+String_Escape(AllChildObjects.name,N'JSON')
        +'":'
        +Coalesce('"'+String_Escape(Convert(NVARCHAR(3750),AllChildObjects.value),N'JSON')+'"','null')
        , ',')
          WITHIN GROUP ( ORDER BY AllChildObjects.NaturalOrder)  +'}' AS attribute
       FROM 
          (--first we get the indexes and their descriptions
          SELECT 'Index' AS type_desc, TheIndexes.name, value,
            TheIndexes.index_id AS naturalOrder
            FROM sys.indexes AS TheIndexes
              LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
                ON epcolumn.major_id = tables.object_id
               AND epcolumn.minor_id = TheIndexes.index_id
               AND epcolumn.class = 7 --an index
               AND epcolumn.name = 'MS_Description' --you may choose a different name
            WHERE TheIndexes.object_id = tables.object_id
          UNION ALL--then we get the columns and their descriptions
          SELECT 'Column' AS type_desc, TheColumns.name, value,
            TheColumns.column_id AS naturalOrder
            FROM sys.columns AS TheColumns
              LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
                ON epcolumn.major_id = tables.object_id
               AND epcolumn.minor_id = TheColumns.column_id
               AND epcolumn.class = 1 --a column or object
               AND epcolumn.name = 'MS_Description' --you may choose a different name
            WHERE TheColumns.object_id = tables.object_id
         UNION ALL
      --then we get the parameters and their descriptions
          SELECT 'Parameter' AS type_desc, TheParameters.name, value,
            TheParameters.parameter_id AS naturalOrder
            FROM sys.parameters AS TheParameters
              LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
                ON epcolumn.major_id = TheParameters.object_id
               AND epcolumn.minor_id = TheParameters.parameter_id
               AND epcolumn.class = 7 --an parameter
               AND epcolumn.name = 'MS_Description' --you may choose a different name
            WHERE TheParameters.object_id = tables.object_id
          UNION ALL --and then we get the constraints, triggers and other child objects
      SELECT Stuff(Lower(Replace(type_desc,'_',' ')),1,1,Upper(Left(type_desc,1)))
       COLLATE DATABASE_DEFAULT , ChildObjects.name,  value, object_id 
        FROM sys.objects AS ChildObjects
             LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
                ON epcolumn.major_id = ChildObjects.object_id
               AND epcolumn.minor_id = 0 --an object
               AND epcolumn.name = 'MS_Description' --you may choose a different name
            WHERE ChildObjects.parent_object_id = tables.object_id
              AND ChildObjects.type <> 'IT'--who wants internal tables?
          ) AllChildObjects
        GROUP BY type_desc
      ) AS EachAttribute
  ) AS Attributes
    FROM sys.objects tables
      LEFT OUTER JOIN sys.extended_properties ep
        ON ep.major_id = tables.object_id
       AND ep.minor_id = 0
       AND ep.name = 'MS_Description'
    WHERE Type IN ('IF', 'FT', 'TF', 'U', 'V')
  FOR JSON AUTO
  );
IF ((SELECT IsJSON(@JSON))=0) SELECT @JSON ELSE RAISERROR ('Bad JSON from statement',16,1 )