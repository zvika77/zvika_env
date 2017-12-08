select cpu.cpu,tme.* from (
select to_char(time,'dd/mm/yy hh24:mi:ss') as time ,sysdate-time as before,node_name,operation||'('||plan_type||')' as operation,event,schema_name,table_name,projection_name,container_count,(total_size_in_bytes/1024)::number(10,2) as size_KB
from dc_tuple_mover_events ) tme
left join
(select rnum,time,node_name,
nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec as 'cpu'
from (
select  to_char(time,'dd/mm/yy hh24:mi:ss') as time ,node_name
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
,row_number () over (partition by node_name order by time desc , node_name) as rnum
from dc_cpu_aggregate_by_second  
) a
where rnum =1 ) cpu
on (tme.node_name = cpu.node_name)
ORDER BY tme.TIME desc
