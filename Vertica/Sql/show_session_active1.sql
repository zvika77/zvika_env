select avg_cpu_now,client_id,trx_stm as 'trx/stm',session_id,user_name,current_statement
,dur,client_hostname
 from (
select   NVL(case when current_statement like 'COPY%' then REGEXP_SUBSTR(current_statement,'(/tmp/)(\w+).',1,1,'',2) 
 when regexp_like (current_statement , '\w*label\(monitor') then 'monitor' else REGEXP_SUBSTR(current_statement,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,case when transaction_id is not null then transaction_id||'/'||statement_id else 'ZOMBIE' end as 'trx_stm',session_id,user_name,substr(current_statement,1,80) as current_statement,sysdate-statement_start::timestamp as dur,client_hostname
from sessions
where current_statement != ''  or statement_id is not null ) a
left join
(select 
avg(nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec)::number(10,2) as 'avg_cpu_now'
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
order by dur desc 
;
