set timezone to 'Asia/Jerusalem';



select query_start,b4_sec,(avg(avg_cpu))::number(10,2) avg_avgcpu, (avg(max_cpu))::number(10,2) avg_maxcpu ,(sum(above70)/sec*100)::number(10,2) as '%above70',client,Sec,trx_id_stm_id as "trx_id/stm_id",user_name,t_name,identifier ,query,rows ,
err
from (
select cpu.time,cpu.avg_cpu::int,cpu.max_cpu,qp.client,Sec,exe,trx_id_stm_id ,user_name,t_name,identifier,
(timestampdiff('SECOND',query_start_v::timestamptz,sysdate))::int as b4_sec ,query
,query_start,rows,err 
,case when avg_cpu >= 70 then 1 else 0 end as above70
from (
select 
query_start_v,
TIMESTAMPADD('SECOND',Sec,to_timestamptz(query_start,'dd/mm/yy hh24:mi:ss'))  as query_end
,client
,exe,trx_id_stm_id ,user_name,t_name,session_id,identifier,query
,query_start,sysdate,Sec,rows,err
 from 
(
select   NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client
,is_executing as exe,
qpo.transaction_id||' / '||qpo.statement_id as "trx_id_stm_id",
identifier,qpo.user_name,
substr(qpo.schema_name||'.'||qpo.table_name,1,30) as t_name,
session_id,
substr(replace(query,chr(10),' '),1,35) as query,
to_char(query_start::timestamp,'dd/mm/yy hh24:mi:ss') query_start,sysdate,
decode(is_executing,true,extract (seconds from (sysdate::timestamp - query_start::timestamp))+(extract (minutes from (sysdate::timestamp - query_start::timestamp))*60)+(extract (hours from (sysdate::timestamp-query_start::timestamp))*60*60),query_duration_us/1000000)::int as Sec,
processed_row_count as rows,
error_code as err,
query_start::timestamptz as query_start_v
from query_profiles qpo
where (identifier in ('dash_spend_rec_engine','dash_display_report_chart_cost','cross_channel_chart','affiliate_report_chart_cost','dash_device_chart_cost','dash_geo','cross_channel_perf','cross_channel_influence_chart')
 or  table_name =  'dash_session_tmp_spend_reco_calced' )
and user_name = 'dash_v2user' 

) a  order by 1  desc) qp
left join
(select time 
,(avg(nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec))::number(10,2) as 'avg_cpu'
,(max(nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec))::number(10,2) as 'max_cpu'
from (
select  trunc(time,'SS')  as time ,node_name
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
from dc_cpu_aggregate_by_second  
) a
group by time )   cpu
on (cpu.time >= qp.query_start_v and cpu.time <= qp.query_end)
) agg
group by query_start,client,Sec,exe,trx_id_stm_id ,user_name,t_name,identifier,b4_sec ,query,rows,err 
order by query_start::timestamptz desc


