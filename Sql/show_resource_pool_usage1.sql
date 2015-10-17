select cpu.cpu,ra.* from (
select ra.node_name,s.user_name,ra.transaction_id||'/'||ra.statement_id as "trx/stm" 
,substr(s.current_statement,1,30) as curr_stm,pool_name,(memory_inuse_kb/1024)::number(30,2) as mem_inuse_mb ,acquisition_timestamp - queue_entry_timestamp as queue_wait
,thread_count,open_file_handle_count
,timestampdiff('minute',statement_start,sysdate) as dur_min
from resource_acquisitions ra left outer join sessions s on (ra.transaction_id = s.transaction_id and ra.statement_id = s.statement_id)
where (ra.node_name ilike :1 or pool_name ilike :1 or user_name ilike :1 or ra.transaction_id::varchar = :1)
and is_executing = true
)  ra
left join
(select node_name,
(nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec) as 'cpu'
from (
select  to_char(time,'dd/mm/yy hh24:mi:ss') as time ,node_name
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
,row_number () over (partition by node_name order by time desc , node_name) as rnum
from dc_cpu_aggregate_by_second  
) a
where rnum =1 ) cpu
on (ra.node_name = cpu.node_name)
order by 4,ra.node_name 

