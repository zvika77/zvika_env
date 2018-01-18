select max(event_time) as last_event,trim(pui.usename) as user_name,sae.query,substring(querytxt,1,50) as text,count(*) num_events,count(distinct event) distinct_events
,max(event) as sample_event --sae.*,squ.*
from STL_ALERT_EVENT_LOG sae   join pg_user_info pui on (sae.userid = pui.usesysid)
left join stl_query squ on (sae.query = squ.query)
where trim(usename) ilike :1
 group by user_name,sae.query,querytxt
order by 1 desc
