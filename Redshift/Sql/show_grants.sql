SELECT *
FROM
    (
    SELECT
	owner
        ,schemaname
        ,objectname
        ,usename
        ,case when HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'select') = false then null else true end  AS sel
        ,case when HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'insert') = false then null else true end AS ins
        ,case when HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'update') = false then null else true end AS upd
        ,case when HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'delete') = false then null else true end AS del
        ,case when HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'references') = false then null else true end AS ref
    FROM
        (
        SELECT tableowner as owner,schemaname, 't' AS obj_type, tablename AS objectname, schemaname + '.' + tablename AS fullobj FROM pg_tables
        WHERE schemaname not in ('pg_internal')
        UNION
        SELECT viewowner as owner,schemaname, 'v' AS obj_type, viewname AS objectname, schemaname + '.' + viewname AS fullobj FROM pg_views
        WHERE schemaname not in ('pg_internal')
        ) AS objs
         CROSS JOIN (SELECT * FROM pg_user) AS usrs
    ) all_objs
WHERE (all_objs.sel = true or all_objs.ins = true or all_objs.upd = true or all_objs.del = true or all_objs.ref = true)
and trim(schemaname) ilike :1 and trim(objectname) ilike :2
and trim(usename) ilike :3;

SELECT
         SUBSTRING(
           CASE WHEN CHARINDEX('r', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', SELECT'     ELSE '' END
        || CASE WHEN CHARINDEX('w', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', UPDATE'     ELSE '' END
        || CASE WHEN CHARINDEX('a', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', INSERT'     ELSE '' END
        || CASE WHEN CHARINDEX('d', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', DELETE'     ELSE '' END
        || CASE WHEN CHARINDEX('R', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', RULE'       ELSE '' END
        || CASE WHEN CHARINDEX('x', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', REFERENCES' ELSE '' END
        || CASE WHEN CHARINDEX('t', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', TRIGGER'    ELSE '' END
        || CASE WHEN CHARINDEX('X', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', EXECUTE'    ELSE '' END
        || CASE WHEN CHARINDEX('U', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', USAGE'      ELSE '' END
        || CASE WHEN CHARINDEX('C', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', CREATE'     ELSE '' END
        || CASE WHEN CHARINDEX('T', SPLIT_PART( SPLIT_PART( ARRAY_TO_STRING( RELACL, '|' ), pu.groname, 2 ) , '/', 1 ) ) > 0 THEN ', TEMPORARY'  ELSE '' END
           , 3,10000) as priv,
         namespace as schema , item as object , pu.groname  as group,relacl
FROM    (SELECT      use.usename AS subject
                    ,nsp.nspname AS namespace
                    ,cls.relname AS item
                    ,cls.relkind AS type
                    ,use2.usename AS owner
                    ,cls.relacl
        FROM        pg_user     use
        CROSS JOIN  pg_class    cls
        LEFT JOIN   pg_namespace nsp
        ON          cls.relnamespace = nsp.oid
        LEFT JOIN   pg_user      use2
        ON          cls.relowner = use2.usesysid
        WHERE       cls.relowner = use.usesysid
        AND         nsp.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
        ORDER BY     subject
                    ,namespace
                    ,item )
JOIN    pg_group pu ON array_to_string(relacl, '|') LIKE '%'|| pu.groname ||'%'
WHERE schema ilike :1 and object ilike :2 and groname ilike :3
    --relacl IS NOT NULL
ORDER BY schema,object,groname;

