select  client
,Sec,exe,trx_id_stm_id as "trx_id/stm_id",user_name,t_name,identifier,query
,(timestampdiff('SECOND',query_start_v::timestamptz,sysdate))::int as b4_sec
,query_start,session_id,rows,err
 from 
(
select   NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client
,is_executing as exe,
qpo.transaction_id||' / '||qpo.statement_id as "trx_id_stm_id",
identifier,qpo.user_name,
substr(qpo.schema_name||'.'||qpo.table_name,1,30) as t_name,
session_id,
substr(replace(query,chr(10),' '),1,35) as query,
to_char(query_start::timestamptz,'dd/mm/yy hh24:mi:ss') as query_start,sysdate::timestamptz,
decode(is_executing,true,extract (seconds from (sysdate::timestamptz - query_start::timestamptz))+(extract (minutes from (sysdate::timestamptz - query_start::timestamptz))*60)+(extract (hours from (sysdate::timestamptz-query_start::timestamptz))*60*60),query_duration_us/1000000)::int as Sec,
processed_row_count as rows,query_start::timestamptz as query_start_v
,error_code as err
from query_profiles qpo
where (identifier in ('dash_spend_rec_engine','dash_display_report_chart_cost','cross_channel_chart','affiliate_report_chart_cost','dash_device_chart_cost','dash_geo','cross_channel_perf','cross_channel_influence_chart')
 or  table_name =  'dash_session_tmp_spend_reco_calced' )
and (user_name = 'dash_v2user' or user_name = 'dash_prod' )
) a
order by b4_sec --query_start::timestamptz desc  ;

