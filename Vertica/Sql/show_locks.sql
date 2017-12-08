select lck.transaction_id trx_id,STATEMENT_ID stm_id,object_name,lock_mode,lock_scope,to_char(request_timestamp,'dd/mm/yy hh24:mi:ss') as req_time,to_char(grant_timestamp,'dd/mm/yy hh24:mi:ss') grant_time
,user_name,client_hostname,substr(current_statement,1,35) stm
from v_monitor.locks lck left outer join sessions ses ON (lck.transaction_id = ses.transaction_id)
WHERE object_name ilike :1 OR user_name ilike :1;
