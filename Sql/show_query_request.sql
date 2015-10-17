select start_timestamp,user_name,request_type,request_label,session_id,
transaction_id||'/'||statement_id as trx,memory_acquired_mb as acquireMB
,case when success = True then 0 else error_count end as errors ,(request_duration_ms/1000)::int as sec,request 
from sys_history.hist_v_monitor_query_requests  
where (user_name ilike :1 or request_label ilike :1  or request_type ilike :1 or session_id ilike :1 or transaction_id::varchar ilike :1 )

