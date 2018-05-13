select swq.final_state,swq.service_class,trim(pui.usename) as user_name,substring(squ.querytxt,1,60) as text,squ.pid,swq.xid,swq.query
  ,swq.slot_count,date_trunc('seconds',swq.service_class_start_time) as start_time
  ,datediff('seconds',swq.service_class_start_time,swq.service_class_end_time) as service_class_dur_sec
,datediff('seconds',swq.queue_start_time,swq.queue_end_time) as queue_dur_sec
,datediff('seconds',swq.exec_start_time,swq.exec_end_time) as exec_dur_sec
from STL_WLM_QUERY swq LEFT JOIN stl_query squ
    on (swq.query = squ.query)
LEFT JOIN  pg_user_info pui on (swq.userid= pui.usesysid)
where service_class > 4
and  (swq.query ilike :1::int or swq.xid = :1::int or  squ.pid = :1::int ) 
order by service_class_start_time desc ;

