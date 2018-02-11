select *
,(ratio_to_report(size_mb) over () *100)::numeric(10,2) as rat
from (
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
WHERE  trim(sti.schema) ilike  :1 and trim("name") ilike  :2
GROUP BY schema,name,col, attname
order by COUNT(*)  desc ) A
order by size_mb desc

