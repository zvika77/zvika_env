select --NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) 
-- when regexp_like (query , '\w*label\(monitor') then 'monitor' else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
cont,slice_seconds,min_query_start as query_start,query_end,dur_sec,identifier,user_name,query_type,transaction_id,statement_id as stm,substr(query,1,50) as query
 from (
select   count(*) over (partition by slice_seconds) as cont
                        ,b.*, a.*
from    (
                        select slice_time as slice_seconds
                        from (
                                        select   sysdate::timestamp -1/24 as min_time
                                        from dual
                                        union all
                                        select  sysdate::timestamp  as max_time
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
                        from query_profiles qp
                        where 
                                                        query_start::timestamptz at timezone 'US/Pacific'   +  (query_duration_us/1000000/60/60/24) >=  sysdate -1/24
                        and query_type not in ('SET','SHOW')
                        and query  != 'SELECT 1'
--                        and  REGEXP_LIKE(query,'(from)\s*(v_catalog.types)\s*','i') = false
--			and isutf8(query) = 't'
                        ) a
on b.slice_seconds between min_query_start and query_end
) a
order by 2 desc
