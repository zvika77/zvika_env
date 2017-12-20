SELECT trim(schema) as schema,
trim(name) as tname,
col, trim(attname) as col_name, 
COUNT(*) AS "size_mb"
FROM stv_blocklist bl
JOIN stv_tbl_perm perm ON (bl.tbl = perm.id AND bl.slice = perm.slice)
join SVV_TABLE_INFO sti on (bl.tbl = sti.table_id)
LEFT JOIN pg_attribute attr ON
  attr.attrelid = bl.tbl
  AND attr.attnum-1 = bl.col
WHERE  trim(sti.schema) = :1
and trim(perm.name) ilike :2
GROUP BY schema,name,col, attname
order by 1,2,3

