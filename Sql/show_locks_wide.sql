select node_names,lck.transaction_id trx_id,STATEMENT_ID stm_id,object_name,lock_mode,lock_scope,request_timestamp,grant_timestamp 
user_name,client_hostname,current_statement
from v_monitor.locks lck join sessions ses ON (lck.transaction_id = ses.transaction_id)
WHERE object_name ilike :1 OR user_name ilike :1;
