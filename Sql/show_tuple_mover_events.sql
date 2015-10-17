select tm1.time::datetime,sysdate-tm1.time as before,substr(tm1.node_name,instr(tm1.node_name,'node')) as node_name,
tm1.session_id||'/'||tm1.transaction_id AS sess_trx,tm1.operation||'('||tm1.plan_type||')' as operation,tm1.event,tm2.event,tm1.schema_name
,tm1.table_name,tm1.projection_name,tm1.container_count,(tm1.total_size_in_bytes/1024)::number(10,2) as size_KB
from (select * from dc_tuple_mover_events where event = 'Start' ) tm1  left outer join (select * from dc_tuple_mover_events where event = 'Complete' ) tm2 
on (tm1.node_name = tm2.node_name and tm1.session_id = tm2.session_id  and tm1.transaction_id = tm2.transaction_id)
where tm1.schema_name ilike :1
and tm1.table_name ilike :2
ORDER BY tm1.TIME desc
