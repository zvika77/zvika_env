select ra.node_name,s.user_name,ra.transaction_id||'/'||ra.statement_id as "trx/stm" 
,substr(s.current_statement,1,30) as curr_stm,pool_name,(memory_inuse_kb/1024)::number(30,2) as mem_inuse_mb ,acquisition_timestamp - queue_entry_timestamp as queue_wait
,thread_count,open_file_handle_count
,(duration_ms/1000)::int as dur_sec,client_hostname
from resource_acquisitions ra left outer join sessions s on (ra.transaction_id = s.transaction_id and ra.statement_id = s.statement_id)
where (ra.transaction_id::varchar = :1 and ra.statement_id::varchar = :2)
order by 3,node_name ;

