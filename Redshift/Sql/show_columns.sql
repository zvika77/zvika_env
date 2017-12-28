select * from (select schemaname
    , tablename
    ,col_name ,col_datatype ,col_nullable , col_default ,col_encoding
    FROM
    (
    SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 100000000 + a.attnum AS seq
    , CASE WHEN a.attnum > 1 THEN ',' ELSE '' END AS col_delim
    , a.attname  AS col_name
    , CASE WHEN STRPOS(UPPER(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING') > 0
    THEN REPLACE (UPPER(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING', 'VARCHAR')
    WHEN STRPOS(UPPER(format_type(a.atttypid, a.atttypmod)), 'CHARACTER') > 0
    THEN REPLACE (UPPER(format_type(a.atttypid, a.atttypmod)), 'CHARACTER', 'CHAR')
    ELSE UPPER(format_type(a.atttypid, a.atttypmod))
    END AS col_datatype
    , CASE WHEN format_encoding((a.attencodingtype):: INTEGER ) = 'none'
    THEN ''
    ELSE 'ENCODE ' + format_encoding((a.attencodingtype):: INTEGER )
    END AS col_encoding
    , CASE WHEN a.atthasdef IS TRUE THEN 'DEFAULT ' + adef.adsrc ELSE '' END AS col_default
    , CASE WHEN a.attnotnull IS TRUE THEN 'NOT NULL' ELSE '' END AS col_nullable
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN pg_attribute AS a ON C.oid = a.attrelid
    LEFT OUTER JOIN pg_attrdef AS adef ON a.attrelid = adef.adrelid AND a.attnum = adef.adnum
    WHERE C.relkind = 'r'
    AND a.attnum > 0 order by a.attnum ) a ) cols
    where cols.schemaname = :1 and cols.tablename ilike :2
order by 1,2
    ;

