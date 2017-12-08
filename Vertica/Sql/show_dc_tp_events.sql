select substr(node_name,length(node_name)-7) as node_name,schema_name,projection_name,sysdate-time as diff,to_char(sysdate,'hh24:mi:ss') as now_d,to_char(time,'dd/mm/yy hh24:mi:ss') as time_d,operation,plan_type,event,container_count as ROS_count,total_size_in_bytes/1024/1024 as total_MB
from dc_tuple_mover_events
where schema_name ilike :1
and (table_name ilike :2 or projection_name ilike :2 or node_name ilike :2 )
and plan_type ilike :3
order by time desc 
;
