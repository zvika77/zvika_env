select to_char(time,'dd/mm/yy hh24:mi:ss') as time_d,sysdate-time as time_diff,
CASE WHEN (error_level = 17) THEN 'INFO'
            WHEN (error_level = 18) THEN 'NOTICE'
            WHEN (error_level = 19) THEN 'WARNING'
            WHEN (error_level = 20) THEN 'ERROR'
            WHEN (error_level = 21) THEN 'ROLLBACK'
            WHEN (error_level = 22) THEN 'INTERNAL'
            WHEN (error_level = 23) THEN 'FATAL'
            WHEN (error_level = 24) THEN 'PANIC'
            ELSE 'OTHER' end as  error_level
,error_code,transaction_id,statement_id,de.node_name,de.user_name,message
from dc_errors  de 
where (de.user_name ilike :1 or de.node_name ilike :1 or function_name ilike :1 or de.transaction_id::varchar ilike :1 or error_code::varchar ilike :1)
and  time >  sysdate - interval :2  MINUTE
order by time desc ;


