select swqs.service_class,swqs.position,swqs.task,swqs.slot_count
  ,date_trunc('seconds',swqs.start_time) as start_time,(swqs.queue_time/1000000)::int as queue_sec
,stq.pid,swqs.query,substring(stq.querytxt,1,60) as text
from STV_WLM_QUERY_QUEUE_STATE swqs join stl_query stq on (swqs.query = stq.query)
left join pg_user pus on (stq.userid = pus.usesysid)
order by position;
