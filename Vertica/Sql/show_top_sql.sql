select
*
from
(
   SELECT
   row_number () over (order by counter_value desc ) as rnum ,
   decode(is_executing,true,'X',null) as run,
   session_id||'/'||transaction_id||'/'||statement_id as "sid/trx_id/stm_id",
   decode(is_executing,true,session_id||'/'||transaction_id||'/'||statement_id,null) as "sid/trx_id/stm_id",
   node_name,
   user_name,
   operator_name,
   path_id ,
   counter_value/1000000 as sec
   FROM v_monitor.execution_engine_profiles
   WHERE (counter_name='execution time (us)' or counter_name = 'clock time (us)')
and is_executing = true
--   and LENGTH(transaction_id::VARCHAR) != 17
)
a
where rnum <= :1
ORDER BY rnum
;
