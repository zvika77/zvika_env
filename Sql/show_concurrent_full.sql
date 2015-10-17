select
slice_minutes
,max_concurrent_queries as max_concu
,max_queries_in_queue as max_in_queue
,max_memory_inuseMB
,avg_dur_sec
,max_dur_sec
,max_queue_time
,avg_cpu_usage
,avg_mem_usage
,avg_net_incoming_per_sec as avg_net_inc_per_sec
,avg_net_outgoing_per_sec as avg_net_out_per_sec
,avg_io_read_per_sec
,avg_io_write_per_sec
from
(
select trunc(slice_seconds,'MI') slice_minutes
,max(count_queries) max_concurrent_queries
,max(max_dur_sec) as max_dur_sec
,(max(avg_dur_sec))::int as avg_dur_sec
,max(max_queries_in_queue)  as max_queries_in_queue
,max(max_queue_time) as max_queue_time
,max(sum_memory_inuseMB) as max_memory_inuseMB
from (
select trunc(slice_seconds,'SS') slice_seconds
,max(count_queries) count_queries
,max(max_dur_sec) as max_dur_sec
,max(avg_dur_sec) as avg_dur_sec
,max(queries_in_queue) max_queries_in_queue
,max(max_queue_time) as max_queue_time
,(sum(memory_inuse_kb)/1024)::int as sum_memory_inuseMB
from (
select trunc(slice_seconds,'SS') slice_seconds
,max(count_queries) count_queries
,max(max_dur_sec) as max_dur_sec
,max(avg_dur_sec) as avg_dur_sec
,count(distinct q.transaction_id||q.statement_id)  as queries_in_queue
,nvl(max(q.max_queue_time),0) as max_queue_time
from (
select slice_seconds
,count(transaction_id) as count_queries
,count(distinct user_name) as dist_users
,count(distinct query_type) dist_query_type
,max(dur_sec) as max_dur_sec
,avg(dur_sec) as avg_dur_sec
 from 	(
			select slice_time as slice_seconds
			from (
					select   (sysdate::timestamptz at timezone 'US/Pacific' - interval :1 hour) as min_time
					from dual
					union all
					select  (sysdate::timestamptz at timezone 'US/Pacific') as max_time
					from dual
					) d
			TIMESERIES slice_time AS '1 second' OVER (ORDER BY min_time)
			) b
left outer join
			(
			select
			query_start::timestamptz at timezone 'US/Pacific' as min_query_start,
			(query_start::timestamptz at timezone 'US/Pacific' +  (query_duration_us/1000000/60/60/24)) as query_end,
			((query_duration_us)/1000000)::number(30,2) as dur_sec,
			user_name,query_type,
			transaction_id,statement_id
			from sys_history.hist_v_monitor_query_profiles qp
			where query_start::timestamptz at timezone 'US/Pacific' + (query_duration_us/1000000/60/60/24) >=  
							sysdate::timestamptz at timezone 'US/Pacific' - interval :1 hour 
			and query_type not in ('SET','SHOW')
			and query  != 'SELECT 1'
			and  REGEXP_LIKE(query,'(from)\s*(v_catalog.types)\s*','i') = false
			) a
on b.slice_seconds between min_query_start and query_end
group by slice_seconds
) a
left join
		(
		select queue_entry_timestamp,acquisition_timestamp,max_queue_time ,transaction_id,statement_id
		from (
		select  trunc(queue_entry_timestamp,'SS') as  queue_entry_timestamp,trunc(acquisition_timestamp,'SS')  as acquisition_timestamp,max_queue_time ,transaction_id,statement_id
 		from (
 		select
 		max(extract(EPOCH FROM (acquisition_timestamp  - queue_entry_timestamp ))) over (partition by transaction_id,statement_id) as max_queue_time,
 		row_number ()  over (partition by transaction_id,statement_id order by (acquisition_timestamp - queue_entry_timestamp) desc ) as rnum,
 		queue_entry_timestamp::timestamptz at timezone 'US/Pacific' as queue_entry_timestamp,acquisition_timestamp::timestamptz at timezone 'US/Pacific' as acquisition_timestamp,release_timestamp::timestamptz at timezone 'US/Pacific' as release_timestamp
 		,transaction_id,statement_id
 		from sys_history.hist_v_monitor_resource_acquisitions
		  where acquisition_timestamp::timestamptz at timezone 'US/Pacific' >=  sysdate::timestamptz at timezone 'US/Pacific' - interval :1 hour
 		and extract (epoch from (acquisition_timestamp - queue_entry_timestamp))::int > 1
 		) a
 		where rnum =1
 		order by 1
 		) q1 ) q
on a.slice_seconds between q.queue_entry_timestamp and q.acquisition_timestamp
group by trunc(slice_seconds,'SS')
order by 1
) z
left join
(
		select  trunc(queue_entry_timestamp,'SS') as  queue_entry_timestamp
		,trunc(acquisition_timestamp,'SS')  as acquisition_timestamp
		,transaction_id,statement_id,memory_inuse_kb
 		from (
 		select
 		max(extract(EPOCH FROM (acquisition_timestamp  - queue_entry_timestamp ))) over (partition by transaction_id,statement_id) as max_queue_time,memory_inuse_kb,
 		row_number ()  over (partition by transaction_id,statement_id order by memory_inuse_kb desc ) as rnum,
 		queue_entry_timestamp::timestamptz at timezone 'US/Pacific' as queue_entry_timestamp,acquisition_timestamp::timestamptz at timezone 'US/Pacific' as acquisition_timestamp,release_timestamp::timestamptz at timezone 'US/Pacific' as release_timestamp
 		,transaction_id,statement_id
 		from sys_history.hist_v_monitor_resource_acquisitions
		  where  acquisition_timestamp::timestamptz at timezone 'US/Pacific' >=  sysdate::timestamptz at timezone 'US/Pacific' - interval :1 hour
 		) a
 		where rnum =1 		
) mem
on z.slice_seconds between mem.queue_entry_timestamp and mem.acquisition_timestamp
group by trunc(slice_seconds,'SS')
) mi
group by trunc(slice_seconds,'MI')
) queries
left join
(select end_time::timestamptz at timezone 'US/Pacific' as end_time
,avg(average_memory_usage_percent) avg_mem_usage
,avg(average_cpu_usage_percent) avg_cpu_usage
,avg(net_rx_kbytes_per_second) avg_net_incoming_per_sec
,avg(net_tx_kbytes_per_second) avg_net_outgoing_per_sec
,avg(io_read_kbytes_per_second) avg_io_read_per_sec
,avg(io_written_kbytes_per_second) avg_io_write_per_sec
from system_resource_usage
where end_time::timestamptz at timezone 'US/Pacific'  >= sysdate::timestamptz at timezone 'US/Pacific' - interval :1 hour
group by end_time
) sru
on (queries.slice_minutes = sru.end_time )
order by 1

