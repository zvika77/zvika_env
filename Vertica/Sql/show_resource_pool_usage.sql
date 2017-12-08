select ra.node_name,s.user_name,ra.transaction_id||'/'||ra.statement_id as "trx/stm" 
,substr(s.current_statement,1,30) as curr_stm,pool_name,(memory_inuse_kb/1024)::number(30,2) as mem_acquired_mb ,acquisition_timestamp - queue_entry_timestamp as queue_wait
,thread_count,open_file_handle_count
,timestampdiff('minute',statement_start,sysdate) as dur_min
from resource_acquisitions ra left outer join sessions s on (ra.transaction_id = s.transaction_id and ra.statement_id = s.statement_id)
where (ra.node_name ilike :1 or pool_name ilike :1 or user_name ilike :1 or ra.transaction_id::varchar = :1)
and is_executing = true
order by 3,node_name ;
