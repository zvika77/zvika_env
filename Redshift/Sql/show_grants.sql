SELECT *
FROM
    (
    SELECT
        schemaname
        ,objectname
        ,usename
        ,owner
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'select') AS sel
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'insert') AS ins
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'update') AS upd
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'delete') AS del
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'references') AS ref
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
and schemaname ilike :1 and objectname ilike :2
and usename ilike :3

