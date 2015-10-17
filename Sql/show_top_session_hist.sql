select in_queue_min,to_char(query_start::timestamp,'dd/mm/yy hh24:mi') as query_start,substr(s.node_name,instr(node_name,'node')) as node_name,s.user_name,s.transaction_id||'/'||s.statement_id as "trx/stm"
,ra.pool_name,avgmax_mem as "avg/max allocated memoryMB" ,(reserved_extra_memory/1024/1024)::number(30,2) as extra_memory_mb 
,identifier,processed_row_count as rows,(query_duration_us/1000000/60)::number(30,2)  dur_min
,avgthreads as "avg_threads",avgfilehandles as "avg_filehandles",substr(query,1,40) as query,error_code
from (select pool_name,transaction_id,statement_id,(avg(memory_inuse_kb/1024))::number(30,2)||'/'||(max(memory_inuse_kb/1024))::number(30,2) as avgmax_mem,
(avg(thread_count))::int as avgthreads,(avg(open_file_handle_count))::int as avgfilehandles,
max(timestampdiff('minute',QUEUE_ENTRY_TIMESTAMP,ACQUISITION_TIMESTAMP)) as in_queue_min
 from sys_history.hist_v_monitor_resource_acquisitions 
where acquisition_timestamp >= to_timestamp(:2,'dd/mm/yy:hh24')  and acquisition_timestamp <= to_timestamp(:3,'dd/mm/yy:hh24')  
and request_type = 'Reserve' and is_executing = false
group by transaction_id,statement_id,pool_name
) ra 
right outer join sys_history.hist_v_monitor_query_profiles  s on (ra.transaction_id = s.transaction_id and ra.statement_id = s.statement_id)
where (session_id ilike :1 or  s.node_name ilike :1 or s.user_name ilike :1 OR s.transaction_id::VARCHAR = :1 OR query_type = :1 or s.identifier ilike :1 )
and s.is_executing = false 
--and query_start::timestamptz >= to_timestamp(:2,'dd/mm/yy:hh24')  and query_start::timestamp <= to_timestamp(:3,'dd/mm/yy:hh24') 
order by query_start 
