select  min(start_time) as start_time,usename,query,count(*) as num_files,sum(line_count) sum_lines,(sum(transfer_size)/1024^2)::int sum_MB
from STL_UNLOAD_LOG sul join pg_user_info pui on (sul.userid = pui.usesysid)
where usename ilike :1
 group by usename,query
order by 1 desc

