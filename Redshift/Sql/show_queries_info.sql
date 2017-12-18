select swq.final_state,swq.service_class,trim(pui.usename) as user_name,substring(squ.querytxt,1,60) as text,squ.pid,swq.xid,swq.query
  ,swq.slot_count,date_trunc('seconds',swq.service_class_start_time) as start_time
  ,datediff('minutes',swq.service_class_start_time,swq.service_class_end_time) as service_class_dur_min
,datediff('minutes',swq.queue_start_time,swq.queue_end_time) as queue_dur_min
,datediff('minutes',swq.exec_start_time,swq.exec_end_time) as exec_dur_min
from STL_WLM_QUERY swq LEFT JOIN stl_query squ
    on (swq.query = squ.query)
LEFT JOIN  pg_user_info pui on (swq.userid= pui.usesysid)
where service_class > 4
and trim(pui.usename) ilike trim(:1)
order by service_class_start_time desc ;

