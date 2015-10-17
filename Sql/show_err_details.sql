\x
SELECT time,dc.node_name,dc.user_name,dc.transaction_id,dc.statement_id,query_type,schema_name,table_name,projections_used,(query_duration_us/1000000)::int as dur_sec,processed_row_count,dc.error_code,query,message
from dc_errors dc left outer join sys_history.hist_v_monitor_query_profiles hqp on (dc.transaction_id = hqp.transaction_id and dc.statement_id = hqp.statement_id)
where  dc.error_code   = :1 or (dc.transaction_id = :1 and dc.statement_id = :2);

