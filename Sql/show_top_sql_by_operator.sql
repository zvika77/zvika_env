select
*
from
(
   SELECT
   row_number () over (order by counter_value desc ) as rnum ,
   decode(is_executing,true,'X',null) as run,
   decode(is_executing,true,eep.session_id||'/'||eep.transaction_id||'/'||eep.statement_id,null) as "sid/trx_id/stm_id",
   eep.node_name,
   ses.client_hostname,
   eep.user_name,
   operator_name,
   path_id ,
   counter_value/1000000 as sec
   FROM v_monitor.execution_engine_profiles eep left outer join v_monitor.sessions ses on ( ses.session_id = eep.session_id)
   WHERE (counter_name='execution time (us)' or counter_name = 'clock time (us)')
)
a
where rnum <= :1
ORDER BY rnum
;

