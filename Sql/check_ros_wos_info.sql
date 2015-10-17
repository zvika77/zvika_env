
select node_name,anchor_table_schema,anchor_table_name,projection_name,row_count,used_bytes/1024/1024 as used_MB,wos_used_bytes/1024/1024 wos_used_MB,ros_used_bytes/1024/1024 ros_used_MB,ros_count
from  v_monitor.projection_storage
where anchor_table_schema ilike :1
and (node_name ilike :2 or anchor_table_name ilike :2 or projection_name ilike :2)
order by ros_count desc ;
