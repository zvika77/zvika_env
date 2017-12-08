\a
\o /tmp/dc_storage.txt

select to_char(time,'dd/mm/yy hh24:mi') as time,node_name,path,device,filesystem,used_bytes_max_value/1024/1024/1024 as used_max_value_GB
,free_bytes_max_value/1024/1024/1024 as free_max_value_GB
from dc_storage_info_by_hour
where node_name ilike :1
and (path ilike  :2 or device ilike :2 or filesystem ilike :2)
order by time,node_name;

\o
\!less /tmp/dc_storage.txt

