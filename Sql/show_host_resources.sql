select substr(node_name,instr(node_name,'node')) as node_name,host_name,i_name,open_files_limit,threads_limit,processor_count cpu,processor_core_count cores
,processor_description cpu_desc,opened_file_count||'/'||opened_socket_count "file/socket open"
,(total_memory_bytes/1024/1024)::number(30,2) as Toatl_memMB
,((total_memory_free_bytes+total_buffer_memory_bytes+total_memory_cache_bytes)/1024/1024)::number(30,2)
||' ('||((total_memory_free_bytes+total_buffer_memory_bytes+total_memory_cache_bytes) / total_memory_bytes*100)::number(4,2)||'%)'  "Free(free+buffer+cache)"
,(total_swap_memory_bytes/1024/1024)::number(30,2) Total_swap
,(total_swap_memory_free_bytes/1024/1024)::number(30,2) Swap_free
,(disk_space_total_mb/1024)::number(30,2) Disk_totalGB
,(disk_space_free_mb/1024)::number(30,2)||' ('||(disk_space_free_mb/disk_space_total_mb*100)::number(4,2)||'%)' Disk_free
,(disk_space_used_mb/1024)::number(30,2) Disk_used
from host_resources hr join nodes n on (hr.host_name = n.node_address)
left join sys_history.ec2_ip_to_names ec2 
on (host_name = ip )
where (host_name ilike :1  or node_name ilike :1 or i_name ilike :1)
order by 1
