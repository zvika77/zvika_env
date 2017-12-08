\a
\o /tmp/dc_memory_info.txt

select node_name,time,total_memory_max_MB,free_memory_max_MB,buffer_memory_max_MB,file_cache_memory_max_MB
,total_swap_max_MB,free_swap_max_MB
,free_memory_max_MB+buffer_memory_max_MB+file_cache_memory_max_MB as total_free_MB
from (
select node_name,time as time_order,to_char(time,'dd/mm/yy hh24:mi:ss')as time,total_memory_max_value/1024/1024 total_memory_max_MB
,free_memory_max_value/1024/1024 as free_memory_max_MB,buffer_memory_max_value/1024/1024 as  buffer_memory_max_MB,file_cache_memory_max_value/1024/1024 as file_cache_memory_max_MB
,total_swap_max_value/1024/1024 as total_swap_max_MB,free_swap_max_value/1024/1024 as free_swap_max_MB
from dc_memory_info_by_hour
where node_name ilike :1
order by  node_name,time_order) a ;

\o
\!less /tmp/dc_memory_info.txt

