select query,stm,seg,step,maxtime/1000000||'/'||avgtime/1000000 as max_avg_time_sec,ROWs
,(bytes/1024/1024)::int as MB,rate_row||'/'||(rate_byte/1024/1024)::int as rate_row_mb
,label,decode(is_diskbased,'t','<===',null) as disk,
  case when workmem >0 then (workmem/ (select count(*) slices from stv_slices)/1024/1024)::int else 0 end mem_mb_per_slice
  ,case when workmem >0 then (workmem/1024/1024)::int else 0 end mem_mb_all_slices
  ,rows_pre_filter
from svl_query_summary where query = :1
order by query, seg, step
