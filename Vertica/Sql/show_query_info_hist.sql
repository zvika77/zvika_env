\a
\t

select request from sys_history.hist_v_monitor_query_requests where transaction_id::varchar = :1  and statement_id::varchar ilike :2;


\a
\t

select path_line from sys_history.hist_v_monitor_query_plan_profiles a  where TRANSACTION_id = :1 and a.statement_id =  :2 ;

select
NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,is_executing as exe,
qpo.transaction_id||' / '||qpo.statement_id as "trx_id/stm_id",
identifier,qpo.user_name,
substr(qpo.schema_name||'.'||qpo.table_name,1,30) as t_name,
substr(qpo.projections_used,1,25) as proj_use,
substr(replace(query,chr(10),' '),1,35) as query,
to_char(query_start::timestamptz,'dd/mm/yy hh24:mi:ss') query_start,sysdate,
(decode(is_executing,true,extract (seconds from (sysdate::timestamp - query_start::timestamp))+(extract (minutes from (sysdate::timestamp - query_start::timestamp))*60)+(extract (hours from (sysdate::timestamp-query_start::timestamp))*60*60),query_duration_us/1000000))::int as Sec,
(RESERVED_EXTRA_MEMORY/1024^3) as extra_memMB
,processed_row_count as rows,
error_code as err
from sys_history.hist_v_monitor_query_profiles qpo
where transaction_id::VARCHAR = :1  and statement_id::varchar ilike :2
order by query_start::timestamptz desc,query_duration_us desc  ;




select 
NVL(case when request like 'COPY%' then REGEXP_SUBSTR(request,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(request,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,start_timestamp,user_name,request_type,request_label,session_id,memory_acquired_mb,node_name,
transaction_id||'/'||statement_id as trx,case when success = True then 0 else error_count end as errors ,(request_duration_ms/1000)::int as sec
from sys_history.hist_v_monitor_query_requests  
where transaction_id::varchar = :1  and statement_id::varchar ilike :2
;





select ra.node_name,ra.transaction_id||'/'||ra.statement_id as "trx/stm" 
,pool_name,(memory_inuse_kb/1024)::number(30,2) as mem_inuse_mb ,(acquisition_timestamp - queue_entry_timestamp) as queue_wait
,thread_count,open_file_handle_count
,(duration_ms/1000)::int as dur_sec
from sys_history.hist_v_monitor_resource_acquisitions ra
where ra.transaction_id::varchar ilike :1 and statement_id::varchar ilike :2
order by 2,node_name ;

