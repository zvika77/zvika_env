-- 2\ hours


select date_trunc('hour',starttime) as time,usename,count(sqh.query) as num_queries,count(distinct xid) count_xid
from stl_query sqh left join pg_user_info pui on (sqh.userid = pui.usesysid)
 where trim(usename) ilike :1
  and date_trunc('hour',starttime)  > sysdate - interval :2
group by date_trunc('hour',starttime) ,usename
order by 1 desc, 2  ;
