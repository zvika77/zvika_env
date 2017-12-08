select node_name,transaction_id,statement_id,request_type,count(*) as num_requests,pool_name,succeeded,(max(memory_kb)/1024)::int MB,max(filehandles) filehandles,max(threads) threads
from dc_resource_acquisitions where transaction_id = :1 and statement_id = :2
group by node_name,transaction_id,statement_id,request_type,pool_name,succeeded
order by node_name,request_type desc ;

