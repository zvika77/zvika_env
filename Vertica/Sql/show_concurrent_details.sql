select NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) 
 when regexp_like (query , '\w*label\(monitor') then 'monitor' else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,cont,slice_seconds,min_query_start as query_start,query_end,dur_sec,memory_mb,filehandles,threads,identifier,user_name,query_type,transaction_id,statement_id as stm,substr(query,1,50) as query
 from (
select   count(*) over (partition by slice_seconds) as cont
                        ,b.*, a.min_query_start,query_end,dur_sec,identifier,user_name,query_type,a.transaction_id,a.statement_id,query
                        ,memory_mb,filehandles,threads
from    (
                        select slice_time as slice_seconds
                        from (
                                        select   :1::timestamp as min_time
                                        from dual
                                        union all
                                        select  :2::timestamp  as max_time
                                        from dual
                                        ) d
                        TIMESERIES slice_time AS '1 second' OVER (ORDER BY min_time)
                        ) b
left outer join
                        (
                        select
                        query_start::timestamptz at timezone 'US/Pacific' min_query_start,
                        (query_start::timestamptz  at timezone 'US/Pacific' +  (query_duration_us/1000000/60/60/24)) as query_end,
                        ((query_duration_us)/1000000)::number(30,2) as dur_sec,identifier,
                        user_name,query_type,
                        transaction_id,statement_id,query
                        from sys_history.hist_v_monitor_query_profiles qp
                        where query_start::timestamptz at timezone 'US/Pacific' <=  :2
                                                        and query_start::timestamptz at timezone 'US/Pacific'   +  (query_duration_us/1000000/60/60/24) >=  :1
                        and query_type not in ('SET','SHOW')
                        and query  != 'SELECT 1'
                        ) a
on b.slice_seconds between min_query_start and query_end
left outer join
(
select
                transaction_id,statement_id,pool_name,(max(memory_kb)/1024)::int memory_mb,max(filehandles) filehandles,max(threads) threads
                from dc_resource_acquisitions
                group by transaction_id,statement_id,pool_name      ) mem
on (a.transaction_id = mem.transaction_id and a.statement_id = mem.statement_id )
) a
order by 3
