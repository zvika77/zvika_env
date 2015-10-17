set timezone to 'Asia/Jerusalem';


select time,node_name,nice_usage_in_sec,user_usage_in_sec,system_usage_in_sec,
nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec as total_usage
from (
select  to_char(time,'dd/mm/yy hh24:mi:ss') as time ,node_name--,nice_microseconds_start_value,nice_microseconds_end_value ,1*1000000 as total_micro_in_sec,number_of_processors
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
--,user_microseconds_start_value,user_microseconds_end_value
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
--,system_microseconds_start_value,system_microseconds_end_value
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
from dc_cpu_aggregate_by_second  where node_name ilike :1
and time >= to_timestamptz(:2,'dd/mm/yy:hh24mi') and time <= to_timestamp(:3,'dd/mm/yy:hh24mi') 
) a
order by time desc 
