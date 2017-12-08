select user_name,count(*) 
from sessions
where current_statement != ''   
group by user_name
order by 2 desc 
;
