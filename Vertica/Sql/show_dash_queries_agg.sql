set timezone to 'Asia/Jerusalem';

select query_start,client,identifier,query,(avg(sec))::number(10,2) avg_sec,max(sec),count(*)
from (
select trunc(query_start,'HH') query_start ,substr(client,1,instr(client,'''',-1)) as client,case when length(identifier) > 0  then identifier else t_name end as identifier,query,Sec
,length(identifier) 
from (
select query_start::timestamptz query_start,
substr(query,instr(query,'client = '),30) client,
identifier,
substr(qpo.schema_name||'.'||qpo.table_name,1,30) as t_name,
substr(replace(query,chr(10),' '),1,6) as query,
decode(is_executing,true,extract (seconds from (sysdate::timestamp - query_start::timestamp))+(extract (minutes from (sysdate::timestamp - query_start::timestamp))*60)+(extract (hours from (sysdate::timestamp-query_start::timestamp))*60*60),query_duration_us/1000000)::int as Sec
from query_profiles qpo
where (identifier in ('dash_display_report_chart_cost','cross_channel_chart','affiliate_report_chart_cost','dash_device_chart_cost','dash_geo','cross_channel_perf','cross_channel_influence_chart')
 or  table_name =  'dash_session_tmp_spend_reco_calced' )
and user_name = 'dash_v2user' or user_name = 'dash_prod' 
) a ) b
group by query_start,client,identifier,query
order by query_start::timestamptz desc ,avg_sec desc
