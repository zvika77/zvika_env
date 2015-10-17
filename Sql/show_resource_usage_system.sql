select node_name,end_time,average_memory_usage_percent as "%avg_mem_us",average_cpu_usage_percent as "%avg_cpu_us",
net_rx_kbytes_per_second,net_tx_kbytes_per_second,io_read_kbytes_per_second,io_written_kbytes_per_second
from system_resource_usage
where node_name ilike :1
order by end_time desc ,node_name
