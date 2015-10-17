select to_char(time,'dd/mm/yy hh24:mi:ss') as time ,sysdate-time as before,node_name,operation||'('||plan_type||')' as operation,event,schema_name,table_name,projection_name,container_count,(total_size_in_bytes/1024)::number(10,2) as size_KB
from dc_tuple_mover_events 
ORDER BY TIME desc
