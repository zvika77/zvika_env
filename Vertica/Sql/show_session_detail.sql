\x
select ses.user_name,qpo.schema_name,qpo.table_name
,ses.node_name,client_hostname,qpo.projections_used
,substr(transaction_description,1,150) as transaction_description
,query_duration_us/1000000 as last_stm_dur_sec,to_char(query_start::timestamp,'dd/mm/yy hh24:mi:ss') as query_start,query_type,processed_row_count,
error_code
,ses.client_hostname,
ses.transaction_id,
ses.statement_id
,current_statement
,decode(current_statement,'','[l] '||last_statement,'[c] '||current_statement) as "stm[curr,last]"
from v_monitor.sessions ses left outer join query_profiles  qpo on  (ses.session_id = qpo.session_id)
where ses.transaction_id  = :1
and (ses.statement_id = :2 or ses.statement_id is null)
order by query_start;


