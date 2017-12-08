select node_name,transaction_id||'/'||statement_id as trx,pool_name,(memory_requested_kb/1024)::int as memory_requested
,priority,position_in_queue,queue_entry_timestamp||'('||(sysdate - queue_entry_timestamp)||')' as queue_entry
from resource_queues
;


select to_char(time,'dd/mm/yy hh24:mi:ss') as time_d,sysdate-time as time_diff,
CASE WHEN (error_level = 17) THEN 'INFO' 
            WHEN (error_level = 18) THEN 'NOTICE' 
            WHEN (error_level = 19) THEN 'WARNING' 
            WHEN (error_level = 20) THEN 'ERROR' 
            WHEN (error_level = 21) THEN 'ROLLBACK' 
            WHEN (error_level = 22) THEN 'INTERNAL' 
            WHEN (error_level = 23) THEN 'FATAL' 
            WHEN (error_level = 24) THEN 'PANIC' 
            ELSE 'OTHER' end as  error_level
,error_code,transaction_id,statement_id,node_name,user_name,message
from dc_errors 
where time >  sysdate - interval '10' MINUTE
order by time desc ;

select node_name,request_count||'('||local_request_count||')' as "req_count(local)",active_thread_count as act_thread,
open_file_handle_count as open_file_handle,(memory_requested_kb/1024)::int as mem_req
,resource_request_reject_count as req_rejected,resource_request_timeout_count as req_timeout
,resource_request_cancel_count as req_cancel
from resource_usage
order by node_name;


select node_name,end_time||'('||sysdate-end_time||')' as end_time,average_memory_usage_percent,average_cpu_usage_percent,net_rx_kbytes_per_second
net_tx_kbytes_per_second,io_read_kbytes_per_second,io_written_kbytes_per_second
from  system_resource_usage  
where end_time = (select max(end_time) from system_resource_usage) 
order by node_name ;

\i show_top_session.sql


