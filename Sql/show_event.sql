select is_executing,event_timestamp||'('||sysdate - event_timestamp||')' as run_before ,event_type,a.transaction_id||'/'||a.statement_id as trx,
query,a.user_name||'/'||schema_name||'/'||table_name as "usr/schema/tbl",query_duration_us/1000000 as query_dur,processed_row_count,reserved_extra_memory
from query_events a left outer join query_profiles c on (a.transaction_id = c.transaction_id and a.statement_id = c.statement_id)
order by event_timestamp desc 
limit :1;
