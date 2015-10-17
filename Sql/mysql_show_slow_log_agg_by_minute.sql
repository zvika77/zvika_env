select hour(start_time),minute(start_time) min,count(*)  from mysql.slow_log  where start_time > date_sub(now(), interval @1 minute) group by hour(start_time),minute(start_time) order by start_time ;
