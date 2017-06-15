select 
row_number() over (order by MB_count desc ) as rnum,
*
,((mb_count / sum(mb_count) over () )*100)::number(10,2)  as percent
from (
SELECT p.projection_schema,
     cast(SUM(ps.wos_row_count::number + ps.ros_row_count::number) as NUMBER(30,2)) AS row_count_sum,
     cast (SUM(ps.wos_used_bytes::int + ps.ros_used_bytes::int)/1024/1024 AS NUMBER(30,2)) AS MB_count
   FROM  v_catalog.projections p
      JOIN v_monitor.projection_storage ps on p.projection_name = ps.projection_name and  p.projection_schema = ps.anchor_table_schema
	where p.projection_schema ilike :1
   GROUP BY p.projection_schema) a
   ORDER BY mb_count desc 
--   limit 20

