\x
select storage_status,node_name,storage_path,storage_usage,throughput,latency
disk_space_used_mb,disk_space_free_mb,disk_space_free_percent
from V_MONITOR.DISK_STORAGE
where (node_name ilike :1 or storage_path ilike :1)

