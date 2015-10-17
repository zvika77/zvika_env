select trunc(seconds,'MI') as minutes ,max(user_concurrent_requests) as max_user_concurrent_requests
,max(total_concurrent_requests) as max_total_concurrent_requests
from (
select trunc(time,'SS') as seconds,user_name,count(*) concurrent_requests
,case when user_name = :1 then sum(count(*) ) over (partition by trunc(time,'SS'),user_name ) else null end  as user_concurrent_requests
,sum(count(*) ) over (partition by trunc(time,'SS') ) as total_concurrent_requests
from dc_requests_issued
where   request_type not in ('SET','SHOW','TRANSACTION','UTILITY')
and time >= trunc(sysdate,'MI') - interval '60 minute' and time < trunc(sysdate,'MI')
and request  != 'SELECT 1'
and  REGEXP_LIKE(request,'(from)\s*(v_catalog.types)\s*','i') = false
group by trunc(time,'SS'),user_name
order by 1 desc  ) a
group by trunc(seconds,'MI')
order by 1 

