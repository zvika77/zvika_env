select schema_name,projection_name,node_name,storage_type,storage_oid,total_row_count,deleted_row_count,(used_bytes/1024/1024)::int  used_mb
from storage_containers 
where schema_name ilike :1 
and projection_name ilike :2 
and node_name ilike :3
order by schema_name,projection_name,node_name,storage_type;
