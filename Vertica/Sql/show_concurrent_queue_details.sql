select *
from (
 		select count(transaction_id) over (partition by trunc(slice_seconds,'SS')) as cont,slice_seconds
 		,queue_entry_timestamp,acquisition_timestamp ,release_timestamp,max_queue_time_per_trx ,transaction_id,statement_id
 		from 
		(select slice_time as slice_seconds
			from (
					select  (:1::timestamp ) as min_time
					from dual
					union all
					select (:2::timestamp )  as max_time
					from dual
					) d
			TIMESERIES slice_time AS '1 second' OVER (ORDER BY min_time) 			
		) ts
 		left outer join  		
		(  select  trunc(queue_entry_timestamp,'SS') as  queue_entry_timestamp,trunc(acquisition_timestamp,'SS')  as acquisition_timestamp
		,release_timestamp,max_queue_time_per_trx ,transaction_id,statement_id
					,memory_inuse_kb	,sum(memory_inuse_kb) over (partition by trunc(queue_entry_timestamp,'SS')) as sum_memory_inuse_kb_sec
					,sum(memory_inuse_kb) over (partition by trunc(acquisition_timestamp,'SS')) as sum_memory_inuse_kb_sec1
 		from (	
 		select 
 		max(extract(EPOCH FROM (acquisition_timestamp - queue_entry_timestamp))) over (partition by transaction_id,statement_id) as max_queue_time_per_trx,
 		row_number ()  over (partition by transaction_id,statement_id order by (acquisition_timestamp - queue_entry_timestamp) desc ) as rnum,
 		queue_entry_timestamp::timestamptz at timezone 'US/Pacific'  as queue_entry_timestamp
 		,acquisition_timestamp::timestamptz at timezone 'US/Pacific' as acquisition_timestamp
 		,release_timestamp::timestamptz at timezone 'US/Pacific'  as release_timestamp
 		,transaction_id,statement_id,memory_inuse_kb
 		from sys_history.hist_v_monitor_resource_acquisitions 
		  where queue_entry_timestamp::timestamptz at timezone 'US/Pacific' <=  :2  and acquisition_timestamp::timestamptz at timezone 'US/Pacific' >=  :1
-- 		and  transaction_id = '49539595907969631'	  -- and statement_id  = 29
 		and extract (epoch from (acquisition_timestamp - queue_entry_timestamp))::int > 1
 		order by 4
 		) a
 		where rnum =1
 		order by 2
 		) q
		on ts.slice_seconds between queue_entry_timestamp and acquisition_timestamp
		) ccc
 		order by 2


