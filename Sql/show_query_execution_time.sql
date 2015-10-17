select time,node_name,user_name,transaction_id||'/'||statement_id as trx, execution_step, completion_time, completion_time - time as Step_Duration
from dc_query_executions where transaction_id = :1 and statement_id = :2;

