select node_name,request_count||'('||local_request_count||')' as "req_count(local)",active_thread_count as act_thread,
open_file_handle_count as open_file_handle,(memory_requested_kb/1024)::int as mem_req
,resource_request_reject_count as req_rejected,resource_request_timeout_count as req_timeout
,resource_request_cancel_count as req_cancel
from resource_usage
order by  node_name 
