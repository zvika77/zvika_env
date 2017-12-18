-- Got it from https://github.com/awslabs/amazon-redshift-utils/blob/master/src/AdminViews/v_generate_tbl_ddl.sql

select ddl from (
    SELECT
    REGEXP_REPLACE (schemaname, '^zzzzzzzz', '') AS schemaname
    , REGEXP_REPLACE(tablename, '^zzzzzzzz', '') AS tablename
    , seq
    , ddl
    FROM
    (
    SELECT
    schemaname
    , tablename
    , seq
    , ddl
    FROM
    (
    --DROP TABLE
    SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 0 AS seq
    , '--DROP TABLE "' + n.nspname + '"."' + C.relname + '";' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    WHERE C.relkind = 'r'
    --CREATE TABLE
    UNION SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 2 AS seq
    , 'CREATE TABLE IF NOT EXISTS "' + n.nspname + '"."' + C.relname + '"' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    WHERE C.relkind = 'r'
    --OPEN PAREN COLUMN LIST
    UNION SELECT n.nspname AS schemaname, C.relname AS tablename, 5 AS seq, '(' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    WHERE C.relkind = 'r'
    --COLUMN LIST
    UNION SELECT
    schemaname
    , tablename
    , seq
    , '\t' + col_delim + col_name + ' ' + col_datatype + ' ' + col_nullable + ' ' + col_default + ' ' + col_encoding AS ddl
    FROM
    (
    SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 100000000 + a.attnum AS seq
    , CASE WHEN a.attnum > 1 THEN ',' ELSE '' END AS col_delim
    , '"' + a.attname + '"' AS col_name
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
    AND a.attnum > 0
    ORDER BY a.attnum
    )
    --CONSTRAINT LIST
    UNION ( SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 200000000 + CAST (con.oid AS INT ) AS seq
    , '\t,' + pg_get_constraintdef(con.oid) AS ddl
    FROM pg_constraint AS con
    INNER JOIN pg_class AS C ON C.relnamespace = con.connamespace AND C.oid = con.conrelid
    INNER JOIN pg_namespace AS n ON n.oid = C.relnamespace
    WHERE C.relkind = 'r' AND pg_get_constraintdef(con.oid) NOT LIKE 'FOREIGN KEY%'
    ORDER BY seq)
    --CLOSE PAREN COLUMN LIST
    UNION SELECT n.nspname AS schemaname, C.relname AS tablename, 299999999 AS seq, ')' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    WHERE C.relkind = 'r'
    --BACKUP
    UNION SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 300000000 AS seq
    , 'BACKUP NO' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN ( SELECT
    SPLIT_PART( KEY, '_', 5) id
    FROM pg_conf
    WHERE KEY LIKE 'pg_class_backup_%'
    AND SPLIT_PART( KEY, '_', 4) = ( SELECT
    OID
    FROM pg_database
    WHERE datname = current_database())) t ON t.id= C.oid
    WHERE C.relkind = 'r'
    --BACKUP WARNING
    UNION SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 1 AS seq
    , '--WARNING: This DDL inherited the BACKUP NO property from the source table' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN ( SELECT
    SPLIT_PART( KEY, '_', 5) id
    FROM pg_conf
    WHERE KEY LIKE 'pg_class_backup_%'
    AND SPLIT_PART( KEY, '_', 4) = ( SELECT
    OID
    FROM pg_database
    WHERE datname = current_database())) t ON t.id= C.oid
    WHERE C.relkind = 'r'
    --DISTSTYLE
    UNION SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 300000001 AS seq
    , CASE WHEN C.reldiststyle = 0 THEN 'DISTSTYLE EVEN'
    WHEN C.reldiststyle = 1 THEN 'DISTSTYLE KEY'
    WHEN C.reldiststyle = 8 THEN 'DISTSTYLE ALL'
    ELSE '<<Error - UNKNOWN DISTSTYLE>>'
    END AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    WHERE C.relkind = 'r'
    --DISTKEY COLUMNS
    UNION SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 400000000 + a.attnum AS seq
    , 'DISTKEY ("' + a.attname + '")' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN pg_attribute AS a ON C.oid = a.attrelid
    WHERE C.relkind = 'r'
    AND a.attisdistkey IS TRUE
    AND a.attnum > 0
    --SORTKEY COLUMNS
    UNION SELECT schemaname, tablename, seq,
    CASE WHEN min_sort <0 THEN 'INTERLEAVED SORTKEY (' ELSE 'SORTKEY (' END AS ddl
    FROM ( SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 499999999 AS seq
    , MIN (attsortkeyord) min_sort FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN pg_attribute AS a ON C.oid = a.attrelid
    WHERE C.relkind = 'r'
    AND abs(a.attsortkeyord) > 0
    AND a.attnum > 0
    GROUP BY 1, 2, 3 )
    UNION ( SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 500000000 + abs(a.attsortkeyord) AS seq
    , CASE WHEN abs(a.attsortkeyord) = 1
    THEN '\t"' + a.attname + '"'
    ELSE '\t, "' + a.attname + '"'
    END AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN pg_attribute AS a ON C.oid = a.attrelid
    WHERE C.relkind = 'r'
    AND abs(a.attsortkeyord) > 0
    AND a.attnum > 0
    ORDER BY abs(a.attsortkeyord))
    UNION SELECT
    n.nspname AS schemaname
    , C.relname AS tablename
    , 599999999 AS seq
    , '\t)' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    INNER JOIN pg_attribute AS a ON C.oid = a.attrelid
    WHERE C.relkind = 'r'
    AND abs(a.attsortkeyord) > 0
    AND a.attnum > 0
    --END SEMICOLON
    UNION SELECT n.nspname AS schemaname, C.relname AS tablename, 600000000 AS seq, ';' AS ddl
    FROM pg_namespace AS n
    INNER JOIN pg_class AS C ON n.oid = C.relnamespace
    WHERE C.relkind = 'r' )
    UNION (
    SELECT 'zzzzzzzz' || n.nspname AS schemaname,
    'zzzzzzzz' || C.relname AS tablename,
    700000000 + CAST (con.oid AS INT ) AS seq,
    'ALTER TABLE ' + n.nspname + '.' + C.relname + ' ADD ' + pg_get_constraintdef(con.oid):: VARCHAR (1024) + ';' AS ddl
    FROM pg_constraint AS con
    INNER JOIN pg_class AS C
    ON C.relnamespace = con.connamespace
    AND C.oid = con.conrelid
    INNER JOIN pg_namespace AS n ON n.oid = C.relnamespace
    WHERE C.relkind = 'r'
    AND con.contype = 'f'
    ORDER BY seq
    )
    ORDER BY schemaname, tablename, seq
    )
)
where schemaname = :1 and tablename ilike :2
ORDER BY schemaname, tablename, seq
