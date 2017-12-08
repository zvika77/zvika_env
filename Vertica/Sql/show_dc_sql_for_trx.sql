\x
select time,node_name,session_id,user_name,
transaction_id,statement_id,is_retry,request_type,request
from dc_requests_issued
where transaction_id::varchar = :1 and statement_id::varchar ilike :2
order by time  ;

\! read -p "Press [Enter] to check query_profile..."
\! read -p "Press [Enter] to check query_profile..."

select query from query_profiles where  transaction_id::varchar = :1 and statement_id::varchar ilike :2
union 
select query from sys_history.hist_v_monitor_query_profiles  where  transaction_id::varchar = :1 and statement_id::varchar ilike :2;

