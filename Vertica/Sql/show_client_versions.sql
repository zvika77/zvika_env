select  case when client_type = '' then substr(client_label,1,10) else client_type end as type,client_version,ssl_state,min(session_start_timestamp) min_start ,max(session_start_timestamp) max_start,count(distinct user_name) distinct_users,count(*)
from sys_history.hist_v_monitor_user_sessions
where session_start_timestamp > sysdate -1
group by case when client_type = '' then substr(client_label,1,10) else client_type end ,client_version,ssl_state
order by count(*) desc

