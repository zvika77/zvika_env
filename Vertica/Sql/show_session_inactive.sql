select  node_name,transaction_id as trx_id,statement_id as stm_id,user_name,session_id,to_char(login_timestamp,'dd/mm/yy hh24:mi:ss') log_time
,to_char(transaction_start,'dd/mm/yy hh24:mi:ss') trx_start,
to_char(statement_start,'dd/mm/yy hh24:mi:ss') stm_start,substr(current_statement,1,35) current_statement
,last_statement_duration_us/1000 last_stm_dur_sec
,client_hostname
from sessions 
where current_statement = '' and statement_start < sysdate - :2/24
and  (user_name ilike :1 or session_id ilike :1 or client_hostname ilike :1);


