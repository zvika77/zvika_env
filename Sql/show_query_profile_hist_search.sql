select to_char(query_start::timestamp,'dd/mm/yy hh24:mi:ss') query_start,
(TIMESTAMPDIFF('minute',query_start::timestamp,sysdate)) as 'b4(min)'
,substr(node_name,instr(node_name,'node',-1))as node,transaction_id||'/'||statement_id as 'trx/stm',user_name,schema_name,table_name,projections_used
,query_type,processed_row_count as num_rows,(query_duration_us/1000000)::NUMBER(10,2) dur_sec,reserved_extra_memory,error_code,substr(query,1,100) query
from sys_history.hist_v_monitor_query_profiles
where query ilike :1
and query_type != 'SET'
order by query_start::timestamptz desc 
