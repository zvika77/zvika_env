select
NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,is_executing as exe,
qpo.transaction_id||' / '||qpo.statement_id as "trx_id/stm_id",
identifier,qpo.user_name,
substr(qpo.schema_name||'.'||qpo.table_name,1,30) as t_name,
session_id,
substr(replace(query,chr(10),' '),1,35) as query,
to_char(query_start::timestamptz,'dd/mm/yy hh24:mi:ss') query_start,sysdate,
(decode(is_executing,true,extract (seconds from (sysdate::timestamp - query_start::timestamp))+(extract (minutes from (sysdate::timestamp - query_start::timestamp))*60)+(extract (hours from (sysdate::timestamp-query_start::timestamp))*60*60),query_duration_us/1000000))::int as Sec,
processed_row_count as rows,
error_code as err
from query_profiles qpo
where (session_id ilike :1 or  node_name ilike :1 or user_name ilike :1 OR transaction_id::VARCHAR = :1 OR query_type = :1 or identifier ilike :1 or 
NVL(case when query like 'COPY%' then REGEXP_SUBSTR(query,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(query,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') like :1 )
and query_type != 'SET'
order by query_start::timestamptz desc,query_duration_us desc  ;

