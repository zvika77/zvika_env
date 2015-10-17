select TO_CHAR(time,'dd/mm/yy hh24:mi:ss') as time_d,sysdate-time as happened ,node_name,projection_schema,projection_name,plan_type,row_count 
from dc_roses_destroyed
where projection_schema ilike :1
and (projection_name ilike :2 or node_name ilike :2 )
order by time desc 
;

