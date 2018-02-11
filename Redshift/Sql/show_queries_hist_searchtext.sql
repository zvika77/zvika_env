select aborted,starttime,datediff('minutes',starttime,endtime) as dur_min ,usename,sqh.query,pid,xid,querytxt
from admin.stl_query_history sqh left join pg_user_info pui on (sqh.userid = pui.usesysid)
 where trim(usename) ilike :1
order by starttime desc  ;

