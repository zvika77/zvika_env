select event_time,trim(pui.usename) as user,query,slice,segment,step,trim(event) as event,trim(solution) as solution
from STL_ALERT_EVENT_LOG sae   join pg_user_info pui on (sae.userid = pui.usesysid)
 where sae.query = :1
order by event_time desc
