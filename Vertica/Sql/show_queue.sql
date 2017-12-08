select count(*),transaction_id||'/'||statement_id as trx,pool_name,max(memory_requested_kb/1024)::int as max_memory_requested_MB
,priority,position_in_queue,min(queue_entry_timestamp)||'('||min(sysdate - queue_entry_timestamp)||')' as queue_entry
from resource_queues
where (node_name ilike :1 or transaction_id::varchar ilike :1 or pool_name ilike :1 )
group by transaction_id||'/'||statement_id ,pool_name
,priority,position_in_queue
order by position_in_queue
