select cpu.*,sts.* from (
select client_id,trx_stm as 'trx/stm',session_id,user_name,current_statement
,dur_min,client_hostname,mem_usMB as mem_acquiredMB,pool_name,thread_count,open_file_handle_count open_files,inqueue_sec
 from (
select   NVL(case when current_statement like 'COPY%' then REGEXP_SUBSTR(current_statement,'(/tmp/)(\w+).',1,1,'',2) 
 when regexp_like (current_statement , '\w*label\(monitor') then 'monitor' else REGEXP_SUBSTR(current_statement,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,case when se.transaction_id is not null then se.transaction_id||'/'||se.statement_id else 'ZOMBIE' end as 'trx_stm',session_id,user_name,substr(current_statement,1,80) as current_statement,
timestampdiff('minute',statement_start,sysdate) as dur_min,client_hostname
,timestampdiff('second',queue_entry_timestamp,acquisition_timestamp) as inqueue_sec
,(vra.memory_inuse_kb/1024)::NUMBER(10,2) as mem_usMB,pool_name,thread_count,open_file_handle_count
,row_number () over (partition by vra.transaction_id,vra.statement_id) as rnum 
from sessions se left outer join resource_acquisitions vra on (se.transaction_id = vra.transaction_id and se.statement_id = vra.statement_id)
where se.current_statement != ''  or se.statement_id is not null ) a
where rnum =1 ) sts
left join
(select 
avg(nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec)::number(10,2) as 'cpu'
from (
select  to_char(time,'dd/mm/yy hh24:mi:ss') as time ,node_name
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
,row_number () over (partition by node_name order by time desc , node_name) as rnum
from dc_cpu_aggregate_by_second  
) a
where rnum =1 ) cpu
on (1=1)
order by sts.dur_min desc 

