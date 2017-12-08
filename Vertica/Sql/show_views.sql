\x
select owner_name,table_name,to_char(create_time,'dd/mm/yy hh24:mi') as create_time,view_definition  
from v_catalog.views
where table_schema ilike :1
and table_name ilike :2;
