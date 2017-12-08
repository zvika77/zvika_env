select is_executing as exec,refresh_start,projection_schema,anchor_table_name,projection_name
,substr(refresh_status,1,30) as refresh_status,refresh_method,refresh_failure_count as failures
,refresh_duration_sec as dur_sec
from v_monitor.PROJECTION_REFRESHES
 where projection_schema ilike :1 
 and (anchor_table_name ilike :2 or projection_name ilike :2)
 order by is_executing desc ,refresh_start desc  ,projection_schema,anchor_table_name,projection_name;
