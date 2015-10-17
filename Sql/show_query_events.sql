select 
to_char(event_timestamp,'dd/mm/yy hh24:mi:ss')||'('||sysdate-event_timestamp||')' as event_timestamp,a.node_name,a.user_name,a.session_id,a.transaction_id||'/'||a.statement_id as trx,path_id,event_category,event_type, substr(request,1,30) as request,is_retry
from 
(select node_name,user_name,session_id,transaction_id,statement_id,request,is_retry
 from dc_requests_issued  where transaction_id  in (
select distinct transaction_id from query_events --where event_timestamp  > trunc(sysdate) 
) ) a 
join query_events b on (a.transaction_id =b.transaction_id and a.statement_id = b.statement_id)
order by event_timestamp desc  ;
