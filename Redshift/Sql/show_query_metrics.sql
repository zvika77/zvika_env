select * from (
select trim(pui.usename) as user_name,sqm.query,sqm.slices,date_trunc('seconds',sqm.starttime) as start_time
  ,case when sqm.segment = -1 and sqm.step_type = -1 then 'QueryLevel'
        when sqm.segment != -1 and sqm.step_type = -1 then 'SegmentLevel'
        when sqm.segment != -1 and sqm.step_type != -1 then 'StepLevel'
   else sqm.segment::varchar end as metric_level
  ,sqm.segment
  ,sqm.step
  ,case when sqm.step_type = -1 then 'NoStepLevel'
  when sqm.step_type = 1 then 'Scan table'
  when sqm.step_type = 2 then 'Insert rows'
  when sqm.step_type = 3 then 'Aggregate rows'
  when sqm.step_type = 6 then 'Sort step'
  when sqm.step_type = 7 then 'Merge step'
  when sqm.step_type = 8 then 'Distribution step'
  when sqm.step_type = 9 then 'Broadcast distribution step'
  when sqm.step_type = 10 then 'Hash join'
  when sqm.step_type = 11 then 'Merge join'
  when sqm.step_type = 12 then 'Save step'
  when sqm.step_type = 14 then 'Hash join'
  when sqm.step_type = 15 then 'Nested loop join'
  when sqm.step_type = 16 then 'Project fields and expressions'
  when sqm.step_type = 17 then 'Limit the number of rows returned'
  when sqm.step_type = 18 then 'Unique'
  when sqm.step_type = 20 then 'Delete rows'
  when sqm.step_type = 26 then 'Limit the number of sorted rows returned'
  when sqm.step_type = 29 then 'Compute a window function'
  when sqm.step_type = 32 then 'UDF'
  when sqm.step_type = 33 then 'Unique'
  when sqm.step_type = 37 then 'Return rows from the compute nodes to the leader node'
  when sqm.step_type = 38 then 'Return rows to the leader node.'
  when sqm.step_type = 40 then 'Spectrum scan.'
else null end as step_type
,sqm.rows||'/'||sqm.max_rows as "rows/max"
,sqm.blocks_read||'/'||sqm.max_blocks_read as blk_readMB
,sqm.blocks_to_disk||'/'||sqm.max_blocks_to_disk  tmp_spaceMB
,sqm.query_scan_size||'/'||sqm.max_query_scan_size as scan_sizeMB
,(sqm.cpu_time/1000000)::int||'/'||(sqm.max_cpu_time/1000000)::int as cput_time_sec
,sqm.run_time||'/'||sqm.max_run_time as run_time
from STl_QUERY_METRICS sqm left join pg_user_info pui on (sqm.userid= pui.usesysid)
where sqm.query = :1 ) a
where metric_level ilike  case when :2 = '1' then 'QueryLevel' when :2 = '2' then 'SegmentLevel' when :2 =  '3' then 'StepLevel' else '%' end
order by segment,step,start_time desc 
