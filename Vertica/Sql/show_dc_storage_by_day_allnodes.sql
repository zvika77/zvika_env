\a
\o /tmp/dc_storage_allnodes.txt

select to_char(time,'yyyymmdd') as time,path,device,filesystem,(sum(used_bytes_max_value)/1024/1024/1024)::number(30,2) as used_max_value_GB
,(sum(free_bytes_max_value)/1024/1024/1024)::number(30,2) as free_max_value_GB
from dc_storage_info_by_day
where (path ilike  :1 or device ilike :1 or filesystem ilike :1)
group by to_char(time,'yyyymmdd'),path,device,filesystem
order by time;
\o
\!less /tmp/dc_storage_allnodes.txt

