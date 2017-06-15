SELECT ps.projection_schema,ps.node_name,
  (SUM(ps.wos_row_count::number + ps.ros_row_count)/1000000)::int AS RowsMilions,
     (SUM(ps.wos_used_bytes::int + ps.ros_used_bytes::int)/1024/1024/1024)::int AS GB
   FROM
       v_monitor.projection_storage ps
        where ps.projection_schema ilike :1
   GROUP BY rollup(ps.projection_schema,ps.node_name)
order by ps.projection_schema,ps.node_name,grouping_id();

