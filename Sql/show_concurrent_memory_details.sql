select
count(transaction_id) over (partition by trunc(slice_seconds,'SS')) as cont
,sum(memory_inuse_mb) over (partition by trunc(slice_seconds,'SS')) as sum_mb
,*
from 	(
			select slice_time as slice_seconds
			from (
					select   :1::timestamp as min_time  -- ( '2014-06-25 19:00:00'::timestamp) as min_time
					from dual
					union all
					select  :2::timestamp as max_time   -- ( '2014-06-25 19:05:00'::timestamp)  as max_time
					from dual
					) d
			TIMESERIES slice_time AS '1 second' OVER (ORDER BY min_time)
			) b
left outer join
		(select  rnum,trunc(queue_entry_timestamp,'SS') as  queue_entry_timestamp
		,trunc(acquisition_timestamp,'SS')  as acquisition_timestamp
		,trunc(release_timestamp,'SS')  as release_timestamp
		,transaction_id,statement_id,(memory_inuse_kb/1024)::int memory_inuse_mb,pool_name
 		from (
 		select
 		max(extract(EPOCH FROM (acquisition_timestamp  - queue_entry_timestamp ))) over (partition by transaction_id,statement_id) as max_queue_time,memory_inuse_kb,
 		row_number ()  over (partition by transaction_id,statement_id order by memory_inuse_kb desc ) as rnum,
 		queue_entry_timestamp::timestamptz at timezone 'US/Pacific' as queue_entry_timestamp,acquisition_timestamp::timestamptz at timezone 'US/Pacific' as acquisition_timestamp,release_timestamp::timestamptz at timezone 'US/Pacific' as release_timestamp
 		,transaction_id,statement_id,pool_name
 		from sys_history.hist_v_monitor_resource_acquisitions
		  where queue_entry_timestamp::timestamptz at timezone 'US/Pacific' <=  :2  and release_timestamp::timestamptz at timezone 'US/Pacific' >=  :1
-- 		and transaction_id = '81064793300185688' and statement_id = 113
 		) a
 		where rnum =1
) mem
on b.slice_seconds between mem.queue_entry_timestamp and mem.release_timestamp
order by slice_seconds
