select NODE_NAME,projection_schema,projection_name,ROW_COUNT,ros_row_count,wos_row_count,ROS_COUNT,(ros_used_bytes/1024/1024)::NUMERIC(9,2) AS ROS_MB,(USED_BYTES/1024/1024)::NUMERIC(9,2) MB
,(row_count / sum(row_count) OVER () * 100)::number(10,2) as 'distribution%'
from v_monitor.projection_storage
where anchor_table_schema ilike :1
and anchor_table_name ilike :2
AND PROJECTION_NAME ILIKE :3
ORDER BY projection_schema,projection_name,NODE_NAME
