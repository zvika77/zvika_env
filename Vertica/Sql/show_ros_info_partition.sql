select 
row_number () over (partition by TABLE_SCHEMA,PROJECTION_NAME order by count(distinct ROS_ID) desc) rnum,
TABLE_SCHEMA,PARTITION_KEY,PROJECTION_NAME,count(distinct ROS_ID) as ros_count
,(count(distinct ROS_ID)/count(distinct node_name) )::int as avg_ros_per_nodes
,count(*) over () as total_partitions
from v_monitor.partitions
where  table_schema = :1
and projection_name  = :2 
and  node_name ilike :3
group by TABLE_SCHEMA,PROJECTION_NAME,PARTITION_KEY
order by table_schema,projection_name,rnum

