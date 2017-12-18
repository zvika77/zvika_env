select query,stm,seg,step,maxtime/1000000||'/'||avgtime/1000000 as max_avg_time_sec,ROWs
,(bytes/1024/1024)::int as MB,rate_row||'/'||(rate_byte/1024/1024)::int as rate_row_mb
,label,decode(is_diskbased,'t','<===',null) as disk,(workmem/1024/1024)::int mem_mb,rows_pre_filter
from svl_query_summary where query = :1
order by query, seg, step;

