SELECT  
to_char(operation_start_timestamp,'dd/mm/yy hh24:mi:ss') as time,(timestampdiff('second',operation_start_timestamp,sysdate))::int b4_sec,node_name,operation_name,plan_type,table_schema,table_name,projection_name,((total_ros_used_bytes)/1024/1024)::int MB
--operation,plan_type,count(*),max(timestampdiff('second',time,sysdate)) as b4_sec container_count,
--,case when count (distinct projection_name) > 1 then count (distinct projection_name)::varchar else max(projection_name) end as proj_name,   max(projection_name) as max_proj,sum(container_count) as sum_ros,(sum(total_size_in_bytes)/1024)::int KB
,ros_count,session_id
FROM tuple_mover_operations a
where (node_name ilike :1 or table_schema ilike :1 or table_name ilike :1 )
and is_executing = 't'
order by 1,3
