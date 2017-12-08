SELECT path_id,
path_is_started p_start,path_is_completed p_complete,running_time,(memory_allocated_bytes/1024/1024)::int allocatedMB,path_line,(read_from_disk_bytes/1024/1024)::int disk_readMB
,(received_bytes/1024)::int as recievedKB,(sent_bytes/1024)::int as sentKB
FROM query_plan_profiles where transaction_id = :1  and statement_id = :2
ORDER BY transaction_id, statement_id, path_id, path_line_index
