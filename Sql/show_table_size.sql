SELECT p.projection_schema,p.anchor_table_name AS table_name,ps.projection_name, -- 460,140,454
     cast(SUM(ps.wos_row_count::number + ps.ros_row_count::number) as NUMBER(30,2)) AS row_count_sum,
     count(*) as count_nodes,
     cast (SUM(ps.wos_used_bytes::int + ps.ros_used_bytes::int)/1024/1024 AS NUMBER(30,2)) AS MB_count,
     cast (SUM(ps.wos_used_bytes::int + ps.ros_used_bytes::int)/(count(*))/1024/1024  AS NUMBER(30,2)) AS MB_per_node
   FROM  v_catalog.projections p
      JOIN v_monitor.projection_storage ps on p.projection_name = ps.projection_name and  p.projection_schema = ps.anchor_table_schema
   where p.projection_schema ilike :1
   and upper(p.anchor_table_name) ilike :2
   GROUP BY p.projection_schema,p.anchor_table_name ,ps.projection_name
   ORDER BY p.projection_schema,p.anchor_table_name ,ps.projection_name;
