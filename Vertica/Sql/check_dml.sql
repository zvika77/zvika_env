select  query_start::timestamptz as query_start,user_name
,schema_name,table_name,transaction_id,query
from sys_history.hist_v_monitor_query_profiles
where schema_name = 'public'
and table_name != ''
and query_type = 'QUERY'
and regexp_like(query,'^insert','i') = false
--and query_start::timestamptz > trunc(sysdate-1)
and table_name not in (select  filter_value from sysdba.monitor_management where monitor_name = 'checkdml' and filter_name = 'table_name'  and enable = 1 and (grace_period > sysdate or grace_period is null) )
order by query_start::timestamptz desc
