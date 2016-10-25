select * from (
select transaction_id ,statement_id,pool_name,(max(memory_kb)/1024)::int max_mb
,max(time) as max_time
from dc_resource_acquisitions
group by transaction_id ,statement_id ,pool_name
order by max_mb desc ) a
limit 10

