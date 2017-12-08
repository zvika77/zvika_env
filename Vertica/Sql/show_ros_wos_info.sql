select node_name,anchor_table_schema,anchor_table_name,projection_name,
row_count,(used_bytes/1024/1024)::NUMBER(10,2) as used_MB,(wos_used_bytes/1024/1024)::NUMBER(10,2) wos_used_MB,(ros_used_bytes/1024/1024)::NUMBER(10,2) ros_used_MB,ros_count
from  v_monitor.projection_storage
WHERE anchor_table_schema ilike :1
AND (anchor_table_name ilike :2 or projection_name ilike :2)
ORDER BY node_name

