select groname,case when sum_len_users > 0 then num_users else  0 end as num_users
from (
select groname,count(*) as num_users,sum(len_users) sum_len_users
from (
SELECT
pg_group.groname,len(array_to_string(grolist,'')) len_users,
pg_user.usename
FROM pg_group left join pg_user on (pg_user.usesysid = ANY(pg_group.grolist))
--WHERE pg_user.usesysid = ANY(pg_group.grolist)
where (groname  ilike  :1 )
) a 
group by 1
 ) a
ORDER BY 1,2
;
