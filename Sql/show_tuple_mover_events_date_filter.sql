select time::datetime,sysdate-time as before,node_name,session_id||'/'||transaction_id AS sess_trx,operation||'('||plan_type||')' as operation,event,schema_name,table_name,projection_name,container_count,(total_size_in_bytes/1024)::number(10,2) as size_KB
from dc_tuple_mover_events 
where schema_name ilike :1
and table_name ilike :2
AND TIME >=  TO_timestamp(:3,'dd/mm/yy:hh24') AND TIME <= TO_timestamp(:4,'dd/mm/yy:hh24')
ORDER BY TIME desc