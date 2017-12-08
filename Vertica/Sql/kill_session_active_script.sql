\a
\t
\o /tmp/kill_session.lst
select 'select CLOSE_SESSION ('''||session_id||''');' from sessions where  (user_name ilike :1 or session_id ilike :1 or client_hostname ilike :1) and current_statement != '';
\o

\! cat  /tmp/kill_session.lst

\echo Run q /tmp/kill_session.lst
