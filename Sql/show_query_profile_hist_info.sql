\echo "***  TOTAL ***"


select user_name,
sum(decode(query_type,'LOAD',1,0)) as LOAD,
sum(decode(query_type,'TRANSACTION',1,0)) as TRANSACTION,
sum(decode(query_type,'QUERY',1,0)) as QUERY,
((sum(decode(query_type,'QUERY',query_duration_us,0)) /  sum(decode(query_type,'QUERY',1,0)))/1000000)::number(10,5) as query_avg_sec,
sum(decode(query_type,'UTILITY',1,0)) as UTILITY,
sum(decode(query_type,'SET',1,0)) as SET,
sum(decode(query_type,'SHOW',1,0)) as SHOW
from dbadmin.QUERY_PROFILES_HIST
where user_name ilike  :1
group by user_name
order by user_name;



\echo "***  PER DAY ***"

select TO_CHAR(trunc(query_start),'dd/mm/yy') AS query_start_d ,user_name,
sum(decode(query_type,'LOAD',1,0)) as LOAD,
sum(decode(query_type,'TRANSACTION',1,0)) as TRANSACTION,
sum(decode(query_type,'QUERY',1,0)) as QUERY,
((sum(decode(query_type,'QUERY',query_duration_us,0)) /  sum(decode(query_type,'QUERY',1,0)))/1000000)::number(10,5) as query_avg_sec,
sum(decode(query_type,'UTILITY',1,0)) as UTILITY,
sum(decode(query_type,'SET',1,0)) as SET,
sum(decode(query_type,'SHOW',1,0)) as SHOW
from dbadmin.QUERY_PROFILES_HIST
where user_name ilike  :1
group by trunc(query_start),user_name
order by trunc(query_start) DESC ,user_name;


\echo "***  PER HOUR ***"

select TO_CHAR(trunc(query_start,'HH'),'dd/mm/yy_hh') AS query_start_d ,user_name,
sum(decode(query_type,'LOAD',1,0)) as LOAD,
sum(decode(query_type,'TRANSACTION',1,0)) as TRANSACTION,
sum(decode(query_type,'QUERY',1,0)) as QUERY,
((sum(decode(query_type,'QUERY',query_duration_us,0)) /  sum(decode(query_type,'QUERY',1,0)))/1000000)::number(10,5) as query_avg_sec,
sum(decode(query_type,'UTILITY',1,0)) as UTILITY,
sum(decode(query_type,'SET',1,0)) as SET,
sum(decode(query_type,'SHOW',1,0)) as SHOW
from dbadmin.QUERY_PROFILES_HIST
where user_name ilike  :1
group by trunc(query_start,'HH'),user_name
order by trunc(query_start,'HH') DESC ,user_name;