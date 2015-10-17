select to_char(query_start,'dd/mm/yy hh24:mi:ss') query_start,
sysdate-query_start as before,
node_name,session_id,transaction_id,statement_id,user_name,schema_name,table_name,projections_used
,query_type,processed_row_count,(query_duration_us/1000000)::NUMBER(10,2) dur_sec,reserved_extra_memory,error_code,substr(query,1,100) query
from sys_history.hist_v_monitor_query_profiles
where ((session_id ilike :1 or  node_name ilike :1 or user_name ilike :1 OR transaction_id::VARCHAR = :1 or query_type ilike :1)
or (schema_name ilike :1 and table_name ilike :2))
and (query_start >= to_timestamp(:2,'dd/mm/yy_hh24') and query_start <= to_timestamp(:3,'dd/mm/yy_hh24'))
order by query_start::timestamptz desc 
