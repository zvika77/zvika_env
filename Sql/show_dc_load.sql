select 
time,node_name,session_id,user_name,transaction_id,statement_id,request_id,event_type,event_description,union_id,load_id,uri,rows_accepted,rows_rejected 
from dc_load_events 
where  (user_name ilike :1 or node_name ilike :1 or session_id ilike :1 or transaction_id::varchar = :1)
order by time  desc 
;
