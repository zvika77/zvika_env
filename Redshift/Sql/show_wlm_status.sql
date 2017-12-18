select sws.service_class,swsc.name,num_queued_queries,num_executing_queries||'/'||swsc.num_query_tasks as num_queries,swsc.query_working_mem as mem_MB
,(swsc.max_execution_time/1000)::int as max_exec_sec
from STV_WLM_SERVICE_CLASS_STATE sws join stv_wlm_service_class_config swsc on (sws.service_class = swsc.service_class)
where sws.service_class > 4 order by 1;
