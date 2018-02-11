select trim(pui.usename) as username,squ.starttime,
  sqm.query_execution_time as dur_sec,sqm.segment_execution_time as seg_dur_sec, -- time info
  sqm.query,substring(squ.querytxt,1,50) as text
   ,sqm.service_class as srv_cls,
  sqm.query_cpu_time as cpu_time_sec ,sqm.query_cpu_usage_percent as cpu_perc,sqm.cpu_skew, -- cpu info
  sqm.query_blocks_read as blk_read,sqm.query_temp_blocks_to_disk as tmp_blk,sqm.io_skew, -- io info
  sqm.scan_row_count as scan_rows,sqm.return_row_count as retu_rows,sqm.join_row_count as join_rows,sqm.nested_loop_join_row_count as nested_join_rows, -- row info
  sqm.spectrum_scan_row_count as spectrum_scan_rows,sqm.spectrum_scan_size_mb as spectrum_size_mb-- spectrum info
from SVL_QUERY_METRICS_SUMMARY sqm
  left join stl_query squ on (sqm.query = squ.query)
  left join pg_user_info pui on (sqm.userid = pui.usesysid)
where trim(pui.usename) ilike  :1
order by squ.starttime desc,pui.usename ;
