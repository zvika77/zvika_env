select max_mb,allocation_succeeded,pool_name,max_time,user_name,a.transaction_id||' / '||a.statement_id as trx,label,request
 from (
select transaction_id ,statement_id,pool_name,(max(memory_kb)/1024)::int max_mb
,max(time) as max_time,min(case when succeeded = True then 'true' else 'false' end) as allocation_succeeded
from dc_resource_acquisitions
group by transaction_id ,statement_id ,pool_name
) a
join (select user_name,transaction_id ,statement_id,label,substr(request,1,50) as request
	from dc_requests_issued) dcri
on  (a.transaction_id = dcri.transaction_id and a.statement_id = dcri.statement_id)
where allocation_succeeded ilike :1
order by max_mb desc 


