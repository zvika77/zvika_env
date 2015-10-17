select TABLE_SCHEMA,PROJECTION_NAME,PARTITION_KEY,NODE_NAME,ROS_ID,(ROS_SIZE_BYTES/1024/1024)::number(10,2) ROS_SIZE_MB,ROS_ROW_COUNT from v_monitor.partitions
where table_schema ilike :1
and projection_name ilike :2
ORDER BY TABLE_SCHEMA,PROJECTION_NAME,PARTITION_KEY,NODE_NAME; 
