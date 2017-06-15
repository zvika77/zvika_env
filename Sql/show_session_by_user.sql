select user_name,count(*) 
from sessions
group by user_name
order by 2 desc 
;
