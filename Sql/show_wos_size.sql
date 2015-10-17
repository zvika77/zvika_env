select wos_type,node_name,(region_virtual_size_kb/1024)::NUMBER(10,2) as virtual_size_MB,
(region_allocated_size_kb/1024)::NUMBER(10,2) as allocated_size_MB,(region_in_use_size_kb/1024)::NUMBER(10,2) as in_use_size_MB
from wos_container_storage 
where  wos_allocation_region = 'Summary'
--and wos_type = 'user';
