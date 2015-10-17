\o /tmp/show_wos_info.log
\t
select 'WOS SIZE' from dual;
\t
\i show_wos_size.sql

\t
select 'WOS TOP 5 OBJECTS' from dual;
\t

\i show_wos_top_objects.sql

\o

\! view /tmp/show_wos_info.log


\!mv /tmp/show_wos_info.log /tmp/show_wos_info.log.old


