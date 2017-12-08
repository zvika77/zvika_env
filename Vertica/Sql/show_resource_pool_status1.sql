select cpu.cpu,rps.* from (
select substr(node_name,instr(node_name,'node')) as node_name,pool_name,
 (memory_inuse_kb/memory_size_actual_kb*100)::int as "%mem_usage",
 (running_query_count/planned_concurrency*100)::int as "%query/plan",
 (running_query_count/max_concurrency*100)::int as "%query/max",
 (memory_size_kb/1024)::int as mem ,
(memory_size_actual_kb/1024)::int as mem_actual,(memory_inuse_kb/1024)::int as mem_inuse
,(general_memory_borrowed_kb/1024)::int as mem_borrowed,
(queueing_threshold_kb/1024)::int as queue_threshold,running_query_count as query_count,planned_concurrency as planned_concu
,max_concurrency as max_concu
,(query_budget_kb/1024)::int as query_budget
FROM RESOURCE_POOL_STATUS
where pool_name ilike :1 ) rps
left join 
(
select rnum,time,substr(node_name,instr(node_name,'node')) as node_name,
nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec as cpu
from (
select  to_char(time,'dd/mm/yy hh24:mi:ss') as time ,node_name
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
,row_number () over (partition by node_name order by time desc , node_name) as rnum
from dc_cpu_aggregate_by_second  
) a
where rnum =1
) cpu
on (rps.node_name = cpu.node_name)
order by rps.node_name
;

