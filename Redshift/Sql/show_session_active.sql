select trim(pui.usename) as user_name,sti.query,sti.slice,swq.slot_count as slots,swq.service_class as srv_cls
 ,sti.xid,sti.pid,date_trunc('second',sti.starttime) as start_time,datediff('minutes',starttime,sysdate) as dur_min
,substring(sti.text,1,60) as text,sti.suspended,(swq.queue_time/1000000)::int as queue_sec
from stv_inflight sti join STV_WLM_QUERY_STATE swq
 on (sti.query = swq.query)
 left join pg_user_info pui on (sti.userid = pui.usesysid)
where sti.pid != pg_backend_pid()
order by dur_min desc
