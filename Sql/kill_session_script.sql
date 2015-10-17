\a
\pset tuples_only
\o kill_session_script.tmp
select 'select CLOSE_SESSION ('''||session_id||''');' from sessions where  user_name = :1 ;
\o

\echo Run Script kill_session_script.tmp