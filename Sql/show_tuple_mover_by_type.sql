\echo Show current and hist events

select 'Hist' as Type,plan_type,max(sysdate)as Now,max(time) as "Last Time",max(sysdate) - max(time) as Before
,max(projection_last_val)as "Last Projection", 
(max(size_last_val)/1024/1024)::NUMBER(10,2) as MB
,max(container_count_last_val) as "Last Ros Count"
from (
select a.*
,last_value(total_size_in_bytes) over (partition by plan_type order by time   rows between Unbounded preceding and Unbounded following ) as size_last_val
,last_value(projection_name) over (partition by plan_type order by time   rows between Unbounded preceding and Unbounded following ) as projection_last_val
,last_value(container_count) over (partition by plan_type order by time   rows between Unbounded preceding and Unbounded following ) as container_count_last_val
from dc_tuple_mover_events a
order by time desc 
) b
group by plan_type
union all
select 'Current' as Type,plan_type,max(sysdate)as Now,max(operation_start_timestamp) as "Last Time",max(sysdate) - max(operation_start_timestamp) as Before
,max(projection_last_val)as "Last Projection",(max(total_ros_used_bytes)/1024/1024)::NUMBER(10,2) as MB 
,max(ros_count_last_val) as "Last Ros Count"
from (
select a.*
,last_value(total_ros_used_bytes) over (partition by plan_type order by operation_start_timestamp   rows between Unbounded preceding and Unbounded following ) as size_last_val
,last_value(projection_name) over (partition by plan_type order by operation_start_timestamp   rows between Unbounded preceding and Unbounded following ) as projection_last_val
,last_value(ros_count) over (partition by plan_type order by operation_start_timestamp   rows between Unbounded preceding and Unbounded following ) as ros_count_last_val
from v_monitor.tuple_mover_operations  a ) b
group by plan_type
order by Before  
