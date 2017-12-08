select ra.node_name,s.user_name,ra.transaction_id||'/'||ra.statement_id as "trx/stm" 
,substr(s.current_statement,1,30) as curr_stm,pool_name,(memory_inuse_kb/1024)::number(30,2) as mem_inuse_mb ,acquisition_timestamp - queue_entry_timestamp as queue_wait
,thread_count,open_file_handle_count
,timestampdiff('minute',statement_start,sysdate) as dur_min,client_hostname
from resource_acquisitions ra left outer join sessions s on (ra.transaction_id = s.transaction_id and ra.statement_id = s.statement_id)
where (ra.transaction_id::varchar = :1 and ra.statement_id::varchar = :2)
and is_executing = true
order by 3,node_name ;


\x
select time,node_name,session_id,user_name,
transaction_id,statement_id,is_retry,request_type,request
from dc_requests_issued
where transaction_id = :1 and statement_id::varchar = :2
order by time  ;


\x


select path_line from dc_explain_plans a  where TRANSACTION_id = :1 and a.statement_id =  :2    ;

select event_timestamp,path_id,operator_name,event_category,event_type,event_details,suggested_action
   from query_events where transaction_id::varchar = :1 and statement_id = :2
   order by event_timestamp,node_name;


