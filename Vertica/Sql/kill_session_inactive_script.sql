\a
\t
\o /tmp/kill_session_inactive.lst
select 'select CLOSE_SESSION ('''||session_id||''');' 
from sessions 
where current_statement = '' and statement_start < sysdate - :2/24
and  (user_name ilike :1 or session_id ilike :1 or client_hostname ilike :1);
\o

\! cat  /tmp/kill_session_inactive.lst

\echo Run q /tmp/kill_session_inactive.lst
