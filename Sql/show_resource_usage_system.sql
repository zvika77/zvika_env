select node_name,end_time,average_memory_usage_percent as "%avg_mem_us",average_cpu_usage_percent as "%avg_cpu_us",
(net_rx_kbytes_per_second/1024)::int as net_rx_mb,(net_tx_kbytes_per_second/1024)::int net_tx_mb ,(io_read_kbytes_per_second/1024)::int io_read_mb,(io_written_kbytes_per_second/1024)::int io_written_mb
from system_resource_usage
where node_name ilike :1
order by end_time desc ,node_name
