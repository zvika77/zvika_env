select usename,query,slice,path,line_count,start_time,end_time,(transfer_size/1024^2)::int as "MB"
from STL_UNLOAD_LOG sul join pg_user_info pui on (sul.userid = pui.usesysid)
where query  = :1
order by start_time desc;
