select node_name,execution_step,completion_time-time as duration 
from dc_query_executions 
where transaction_id = :1  and statement_id = :2
order by 3 ;

SELECT path_id,
path_is_started p_start,path_is_completed p_complete,running_time,(memory_allocated_bytes/1024/1024)::int allocatedMB,substr(path_line,1,80) line,(read_from_disk_bytes/1024/1024)::int disk_readMB
,(received_bytes/1024)::int as recievedKB,(sent_bytes/1024)::int as sentKB
FROM query_plan_profiles where transaction_id = :1  and statement_id = :2
ORDER BY transaction_id, statement_id, path_id, path_line_index
