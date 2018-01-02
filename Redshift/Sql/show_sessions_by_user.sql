select user_name,count(*) counter,min(starttime) as min_starttime,max(starttime) as max_starttime
from stv_sessions where db_name = current_database() group by user_name order by counter desc;

