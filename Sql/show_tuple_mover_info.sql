\o /tmp/tuple_mover_info.log
\t
select 'WOS SIZE' from dual;
\t
\i show_wos_size.sql

\t
select 'MOVEOUT MERGEOUT PER HOUR' from dual;
\t
\i show_tuple_mover_stats_by_hour.sql 

\t
select 'MOVEOUT MERGEOUT TOP OBJECTS' from dual;
\t
\i show_tuple_mover_top_objects.sql


\t
select 'TOP OBJECTS GENERATING ROS CONTAINERS' from dual;
\t
\i show_tuple_mover_top_ros_objects.SQL 

\t
select 'CURRENT AND LAST TUPLE MOVER EVENT PER TYPE' from dual;
\t
\i show_tuple_mover_by_type.sql

\t
select 'LAST TUPLE MOVER EVENT BY TYPE' from dual;
\t
\i show_tuple_mover_last_events_by_type.sql


\t
select 'LAST TUPLE MOVER EVENT' from dual;
\t
\i show_tuple_mover_events.sql


\o

\! view /tmp/tuple_mover_info.log

\!mv /tmp/tuple_mover_info.log /tmp/tuple_mover_info.log.old
