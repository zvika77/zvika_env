select  node_name,transaction_id as trx_id,statement_id as stm_id,user_name,session_id,to_char(login_timestamp,'dd/mm/yy hh24:mi:ss') log_time
,to_char(transaction_start,'dd/mm/yy hh24:mi:ss') trx_start,
to_char(statement_start,'dd/mm/yy hh24:mi:ss') stm_start,substr(current_statement,1,35) current_statement
,(last_statement_duration_us/1000000)::int last_stm_dur_sec
,client_hostname
from v_monitor.sessions
where user_name ilike :1
order by  login_timestamp


