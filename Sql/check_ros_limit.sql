select 
anchor_table_schema,anchor_table_name,projection_name,max(ros_count) ros_count,(max(ros_used_bytes)/1024/1024)::int as MB
from (
select distinct anchor_table_schema,anchor_table_name,projection_name,node_name,
ros_count,ros_used_bytes
from  v_monitor.projection_storage
where anchor_table_name not in   (select  filter_value from sysdba.monitor_management where monitor_name = 'ros_count' and filter_name = 'table_name'  and enable = 1 and (grace_period < sysdate or grace_period is null) )
order by ros_count desc,anchor_table_schema,anchor_table_name,projection_name
) a
group by anchor_table_schema,anchor_table_name,projection_name
order by ros_count desc
