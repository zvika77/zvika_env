select
is_executing as exe,
qpo.transaction_id||' / '||qpo.statement_id as "trx_id/stm_id",
qpo.user_name,
identifier,
substr(qpo.schema_name||'.'||qpo.table_name,1,30) as t_name,
substr(qpo.projections_used,1,25) as proj_use,
substr(replace(query,chr(10),' '),1,35) as query,
to_char(query_start::timestamp,'dd/mm/yy hh24:mi:ss') query_start,
(decode(is_executing,true,extract (seconds from (now()-query_start::timestamp))+(extract (minutes from (now()-query_start::timestamp))*60)+(extract (hours from (now()-query_start::timestamp))*60),query_duration_us/1000000))::int as Sec,
processed_row_count as rows,
error_code as err
from query_profiles qpo
where (session_id ilike :1 or  node_name ilike :1 or user_name ilike :1 OR transaction_id::VARCHAR = :1 OR query_type = :1 or identifier ilike :1)
and is_executing = 'TRUE'
order by is_executing desc ,query_duration_us desc  ;

