select *
,(ratio_to_report(size_mb) over () *100)::numeric(10,2) as rat
from (
SELECT trim(schema) as schema,
trim(name) as tname,
COUNT(*) AS "size_mb"
FROM stv_blocklist bl
JOIN stv_tbl_perm perm ON (bl.tbl = perm.id AND bl.slice = perm.slice)
join SVV_TABLE_INFO sti on (bl.tbl = sti.table_id)
LEFT JOIN pg_attribute attr ON
  attr.attrelid = bl.tbl
  AND attr.attnum-1 = bl.col
WHERE  trim(sti.schema) ilike :1
GROUP BY schema,name
order by count(*) desc ) a
order by size_mb desc 

