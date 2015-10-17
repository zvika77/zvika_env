select schema_name,projection_name,node_name,storage_type,total_row_count,deleted_row_count,used_bytes/1024/1024  used_mb
from storage_containers 
where schema_name ilike :1 
and projection_name ilike :2 
order by schema_name,projection_name,node_name,storage_type;
